import 'package:flutter/material.dart';
import 'package:story_app/data/model/settings.dart';
import 'package:story_app/data/services/shared_preferences_service.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class SettingsProvider extends SafeChangeNotifier {
  final SharedPreferencesService prefService;

  SettingsProvider(this.prefService);

  Settings _settings = Settings();
  Settings get settings => _settings;

  Future<void> loadSettings() async {
    try {
      final setting = await prefService.getSettingValue();
      if (setting == null) throw Exception("Can't load/not found settings");
      _settings = setting;
      notifyListeners();
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    try {
      _settings = _settings.copyWith(isDarkModeEnabled: isDarkMode);
      await prefService.saveSettingValue(_settings);
      notifyListeners();
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  Future<void> setLocale(Locale locale) async {
    try {
      _settings = _settings.copyWith(locale: locale);
      await prefService.saveSettingValue(_settings);
      notifyListeners();
    } catch (e) {
      debugPrint("Error $e");
    }
  }
}
