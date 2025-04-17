class LoginResponse {
  final bool error;
  final String message;
  final LoginResult loginResult;

  LoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        error: json["error"],
        message: json["message"],
        loginResult: LoginResult.fromJson(json["loginResult"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "loginResult": loginResult.toJson(),
      };

  LoginResponse copyWith({
    bool? error,
    String? message,
    LoginResult? loginResult,
  }) =>
      LoginResponse(
        error: error ?? this.error,
        message: message ?? this.message,
        loginResult: loginResult ?? this.loginResult,
      );
}

class LoginResult {
  final String userId;
  final String name;
  final String token;

  LoginResult({
    required this.userId,
    required this.name,
    required this.token,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        userId: json["userId"],
        name: json["name"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "token": token,
      };

  LoginResult copyWith({
    String? userId,
    String? name,
    String? token,
  }) =>
      LoginResult(
        userId: userId ?? this.userId,
        name: name ?? this.name,
        token: token ?? this.token,
      );
}
