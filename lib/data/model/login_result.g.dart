// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResult _$LoginResultFromJson(Map<String, dynamic> json) => _LoginResult(
  userId: json['userId'] as String,
  name: json['name'] as String,
  token: json['token'] as String,
);

Map<String, dynamic> _$LoginResultToJson(_LoginResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'token': instance.token,
    };
