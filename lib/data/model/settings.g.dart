// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Settings _$SettingsFromJson(Map<String, dynamic> json) => _Settings(
  isDarkModeEnabled: json['isDarkModeEnabled'] as bool? ?? false,
  locale:
      json['locale'] == null
          ? const Locale('en')
          : const LocaleConverter().fromJson(json['locale'] as String),
);

Map<String, dynamic> _$SettingsToJson(_Settings instance) => <String, dynamic>{
  'isDarkModeEnabled': instance.isDarkModeEnabled,
  'locale': const LocaleConverter().toJson(instance.locale),
};
