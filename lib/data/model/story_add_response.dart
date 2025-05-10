import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_add_response.freezed.dart';
part 'story_add_response.g.dart';

@freezed
abstract class StoryAddResponse with _$StoryAddResponse {
  const factory StoryAddResponse({
    required bool error,
    required String message,
  }) = _StoryAddResponse;

  factory StoryAddResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryAddResponseFromJson(json);
}
