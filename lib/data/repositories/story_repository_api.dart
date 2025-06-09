import 'dart:typed_data';

import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class StoryRepositoryApi implements StoryRepository {
  final StoryApiService _service;

  StoryRepositoryApi(this._service);

  @override
  Future<DomainResult> addStory(
    Uint8List imageBytes,
    String filename,
    String description, {
    double? lat,
    double? lon,
  }) async {
    try {
      final response = await _service.addStory(
        imageBytes,
        filename,
        description,
        lat: lat,
        lon: lon,
      );
      return DomainResultSuccess(data: null, message: response.message);
    } catch (e) {
      return DomainResultError(message: e.toString());
    }
  }

  @override
  Future<DomainResult> getAllStories({
    int? page,
    int? size,
    int? location = 0,
  }) async {
    try {
      final result = await _service.getAllStories(
        page: page,
        size: size,
        location: location,
      );
      final listStoryEntity =
          result.listStory.map((story) => story.toEntity()).toList();
      return DomainResultSuccess(
        data: listStoryEntity,
        message: result.message,
      );
    } catch (e) {
      return DomainResultError(message: e.toString());
    }
  }

  @override
  Future<DomainResult> getStoryDetail(String id) async {
    try {
      final result = await _service.getStoryDetail(id);
      return DomainResultSuccess(
        data: result.story.toEntity(),
        message: result.message,
      );
    } catch (e) {
      return DomainResultError(message: e.toString());
    }
  }
}
