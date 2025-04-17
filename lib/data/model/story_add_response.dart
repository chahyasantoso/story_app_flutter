class StoryAddResponse {
  final bool error;
  final String message;

  StoryAddResponse({
    required this.error,
    required this.message,
  });

  factory StoryAddResponse.fromJson(Map<String, dynamic> json) =>
      StoryAddResponse(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };

  StoryAddResponse copyWith({
    bool? error,
    String? message,
  }) =>
      StoryAddResponse(
        error: error ?? this.error,
        message: message ?? this.message,
      );
}
