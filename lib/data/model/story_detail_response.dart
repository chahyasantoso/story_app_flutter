import 'package:story_app/data/model/story.dart';

class StoryDetailResponse {
  final bool error;
  final String message;
  final Story story;

  StoryDetailResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      StoryDetailResponse(
        error: json["error"],
        message: json["message"],
        story: Story.fromJson(json["story"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "story": story.toJson(),
      };

  StoryDetailResponse copyWith({
    bool? error,
    String? message,
    Story? story,
  }) =>
      StoryDetailResponse(
        error: error ?? this.error,
        message: message ?? this.message,
        story: story ?? this.story,
      );
}
