import 'dart:typed_data';

abstract class StoryRepository {
  Future<DomainResult> addStory(
    Uint8List imageBytes,
    String filename,
    String description, {
    double? lat,
    double? lon,
  });

  Future<DomainResult> getAllStories({int? page, int? size, int? location = 0});

  Future<DomainResult> getStoryDetail(String id);
}

sealed class DomainResult {}

final class DomainResultSuccess<T> extends DomainResult {
  final T data;
  final String? message;
  DomainResultSuccess({required this.data, this.message});
}

final class DomainResultError extends DomainResult {
  final String? message;
  DomainResultError({required this.message});
}
