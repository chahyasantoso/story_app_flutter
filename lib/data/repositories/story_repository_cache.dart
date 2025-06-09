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

      await _sqliteService.replaceAll(response.listStory);
      final listStoryEntity =
          response.listStory.map((story) => story.toEntity()).toList();

      return DomainResultSuccess(
        data: listStoryEntity,
        message: response.message,
      );
    } catch (e) {
      try {
        final response = await _sqliteService.getAllItems();
        final listStoryEntity =
            response.map((story) => story.toEntity()).toList();
        return DomainResultSuccess(
          data: listStoryEntity,
          message: "from cache",
        );
      } catch (e) {
        return DomainResultError(message: e.toString());
      }
    }
  }

  @override
  Future<DomainResult> getStoryDetail(String id) {
    // TODO: implement getStoryDetail
    throw UnimplementedError();
  }
}
