// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_add_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoryAddResponse _$StoryAddResponseFromJson(Map<String, dynamic> json) =>
    _StoryAddResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$StoryAddResponseToJson(_StoryAddResponse instance) =>
    <String, dynamic>{'error': instance.error, 'message': instance.message};
