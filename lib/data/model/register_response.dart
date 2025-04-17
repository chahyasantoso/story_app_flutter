class RegisterResponse {
  final bool error;
  final String message;

  RegisterResponse({
    required this.error,
    required this.message,
  });

  RegisterResponse copyWith({
    bool? error,
    String? message,
  }) =>
      RegisterResponse(
        error: error ?? this.error,
        message: message ?? this.message,
      );

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
