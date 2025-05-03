import 'package:flutter/material.dart';

class Settings {
  final bool isDarkModeEnabled;
  final Locale locale;

  const Settings({
    this.isDarkModeEnabled = false,
    this.locale = const Locale("en"),
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      isDarkModeEnabled: json["isDarkModeEnabled"],
      locale: Locale(json["locale"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "isDarkModeEnabled": isDarkModeEnabled,
      "locale": locale.languageCode,
    };
  }

  Settings copyWith({
    final bool? isDarkModeEnabled,
    final Locale? locale,
  }) {
    return Settings(
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
      locale: locale ?? this.locale,
    );
  }
}
