import 'dart:typed_data';

import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/data/services/story_sqlite_service.dart';
import 'package:story_app/domain/entities/story_entity.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class StoryRepositoryCache implements StoryRepository {
  final StoryApiService _apiService;
  final StorySqliteService _sqliteService;

  StoryRepositoryCache(this._apiService, this._sqliteService);

  /// add story to api, if success then add to cache
  /// else error
  @override
  Future<DomainResult<void>> addStory(
    Uint8List imageBytes,
    String filename,
    String description, {
    double? lat,
    double? lon,
  }) async {
    try {
      final response = await _apiService.addStory(
        imageBytes,
        filename,
        description,
        lat: lat,
        lon: lon,
      );

      /// can't cache because api doesn't expose the storyId on success...
      /// however there's strategy where you can send a tag in description
      /// and match that desc when getting the story.

      /// final listStory = _apiService.getAllStories(page: 1, size: 5);
      /// final story = listStory.any(match the tag in description);
      /// await _sqliteService.insertItem(story);

      return DomainResultSuccess(data: null, message: response.message);
    } catch (e) {
      return DomainResultError(message: e.toString());
    }
  }

  /// get stories from api, if success add to cache;
  /// else get stories from cache
  @override
  Future<DomainResult<List<StoryEntity>>> getAllStories({
    int? page,
    int? size,
    int? location = 0,
  }) async {
    try {
      final response = await _apiService.getAllStories(
        page: page,
        size: size,
        location: location,
      );

      await _sqliteService.insertAll(response.listStory);
      final listStoryEntity =
          response.listStory.map((story) => story.toEntity()).toList();

      return DomainResultSuccess(
        data: listStoryEntity,
        message: response.message,
      );
    } catch (e) {
      try {
        final listStory = await _sqliteService.getAllItems(
          page: page,
          size: size,
          location: location,
        );

        final listStoryEntity =
            listStory.map((story) => story.toEntity()).toList();

        return DomainResultSuccess(
          data: listStoryEntity,
          message: "from cache",
        );
      } catch (e) {
        return DomainResultError(message: e.toString());
      }
    }
  }

  /// get detail from api, if success upsert cache
  /// else get detail from cache
  @override
  Future<DomainResult<StoryEntity>> getStoryDetail(String id) async {
    try {
      final response = await _apiService.getStoryDetail(id);

      await _sqliteService.insertItem(response.story); // doing an upsert

      return DomainResultSuccess(
        data: response.story.toEntity(),
        message: response.message,
      );
    } catch (e) {
      try {
        final story = await _sqliteService.getItemByStoryId(id);

        return DomainResultSuccess(
          data: story.toEntity(),
          message: "from cache",
        );
      } catch (e) {
        return DomainResultError(message: e.toString());
      }
    }
  }
}
