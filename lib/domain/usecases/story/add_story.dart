import 'dart:typed_data';

import 'package:story_app/domain/repositories/story_repository.dart';

class AddStory {
  final StoryRepository _repo;
  AddStory(this._repo);

  Future<DomainResult> call(
    Uint8List imageBytes,
    String filename,
    String description, {
    double? lat,
    double? lon,
  }) {
    return _repo.addStory(
      imageBytes,
      filename,
      description,
      lat: lat,
      lon: lon,
    );
  }
}
