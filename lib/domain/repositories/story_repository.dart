import 'dart:typed_data';

import 'package:story_app/domain/entities/story_entity.dart';

abstract class StoryRepository {
  Future<DomainResult<void>> addStory(
    Uint8List imageBytes,
    String filename,
    String description, {
    double? lat,
    double? lon,
  });
  Future<DomainResult<List<StoryEntity>>> getAllStories({
    int? page,
    int? size,
    int? location = 0,
  });
  Future<DomainResult<StoryEntity>> getStoryDetail(String id);
}

sealed class DomainResult<T> {}

final class DomainResultSuccess<T> extends DomainResult<T> {
  final T data;
  final String? message;
  DomainResultSuccess({required this.data, this.message});
}

final class DomainResultError<T> extends DomainResult<T> {
  final String? message;
  DomainResultError({this.message});
}
