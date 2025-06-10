import 'dart:typed_data';

import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/data/services/story_sqlite_service.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class StoryRepositoryCache implements StoryRepository {
  final StoryApiService _apiService;
  final StorySqliteService _sqliteService;

  StoryRepositoryCache(this._apiService, this._sqliteService);

  @override
  Future<DomainResult> addStory(
    Uint8List imageBytes,
    String filename,
    String description, {
    double? lat,
    double? lon,
  }) {
    // TODO: implement addStory
    throw UnimplementedError();
  }

  /// always cache the api result. and if api error, use result from cache;
  @override
  Future<DomainResult> getAllStories({
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

  /// try to get detail from api, if error get from cache
  @override
  Future<DomainResult> getStoryDetail(String id) async {
    try {
      final response = await _apiService.getStoryDetail(id);

      await _sqliteService.updateItemByStoryId(id, response.story);

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
