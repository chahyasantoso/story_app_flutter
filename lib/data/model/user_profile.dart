import 'package:firebase_auth/firebase_auth.dart';

class UserProfile {
  final String userId;
  final String name;
  final String token;
  final User? firebaseUser;

  const UserProfile({
    required this.userId,
    required this.name,
    required this.token,
    this.firebaseUser,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json["userId"],
      name: json["name"],
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "token": token,
      };

  UserProfile copyWith({
    String? userId,
    String? name,
    String? token,
    User? firebaseUser,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      token: token ?? this.token,
      firebaseUser: firebaseUser ?? this.firebaseUser,
    );
  }
}
