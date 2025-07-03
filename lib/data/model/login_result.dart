import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:story_app/domain/entities/user_entity.dart';

part 'login_result.freezed.dart';
part 'login_result.g.dart';

@freezed
abstract class LoginResult with _$LoginResult {
  const factory LoginResult({
    required String userId,
    required String name,
    required String token,
  }) = _LoginResult;

  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);

  factory LoginResult.fromEntity(UserEntity entity) => LoginResult(
    userId: entity.userId,
    name: entity.name,
    token: entity.token,
  );
}

extension UserEntityMapper on LoginResult {
  UserEntity toEntity() => UserEntity(userId: userId, name: name, token: token);
}
