import 'dart:typed_data';

import 'package:story_app/data/model/story_add_response.dart';

abstract class StoryRepository {
  /// problem: addStory di implementasi API return nya StoryAddResponse
  /// tapi di implementasi SQLite returnnya int misal
  /// gimana bikin abstract repo yang bisa digunakan oleh semua implementasi???
  ///
  Future<StoryAddResponse> addStory(
    Uint8List imageBytes,
    String filename,
    String description, {
    double? lat,
    double? lon,
  });
}
