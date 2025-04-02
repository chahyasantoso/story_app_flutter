class UserProfile {
  final String name;
  final String token;

  const UserProfile({
    this.name = "",
    this.token = "",
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json["name"],
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "token": token,
      };
}
