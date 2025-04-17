import 'package:story_app/data/model/story.dart';

class StoryListResponse {
  final bool error;
  final String message;
  final List<Story> listStory;

  StoryListResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoryListResponse.fromJson(Map<String, dynamic> json) =>
      StoryListResponse(
        error: json["error"],
        message: json["message"],
        listStory:
            List<Story>.from(json["listStory"].map((x) => Story.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "listStory": List<dynamic>.from(listStory.map((x) => x.toJson())),
      };

  StoryListResponse copyWith({
    bool? error,
    String? message,
    List<Story>? listStory,
  }) =>
      StoryListResponse(
        error: error ?? this.error,
        message: message ?? this.message,
        listStory: listStory ?? this.listStory,
      );
}
