import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
abstract class Settings with _$Settings {
  const factory Settings({
    @Default(false) bool isDarkModeEnabled,
    @Default(Locale('en')) @LocaleConverter() Locale locale,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}

class LocaleConverter implements JsonConverter<Locale, String> {
  const LocaleConverter();

  @override
  Locale fromJson(String json) => Locale(json);

  @override
  String toJson(Locale locale) => locale.languageCode;
}
