import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_notification.dart';
import 'package:restaurant_app/data/model/setting.dart';
import 'package:restaurant_app/data/services/shared_preferences_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferencesService _prefService;

  SettingsProvider(this._prefService);

  String _message = "";
  String get message => _message;

  Setting _setting = Setting();
  Setting get setting => _setting;

  void loadSettings() {
    try {
      _setting = _prefService.getSettingValue();
      _message = "Settings loaded";
    } catch (e) {
      _message = "Failed to load settings";
    }
    notifyListeners();
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    try {
      _setting = _setting.copyWith(isDarkModeEnabled: isDarkMode);
      await _prefService.saveSettingValue(_setting);
      _message = "Saving dark mode saved";
    } catch (e) {
      _message = "Failed to save dark mode";
    }
    notifyListeners();
  }

  Future<void> setDailyReminder(bool isEnabled) async {
    try {
      _setting = _setting.copyWith(
        dailyReminder: _setting.dailyReminder.copyWith(
          isEnabled: isEnabled,
        ),
      );
      await _prefService.saveSettingValue(_setting);
      _message = "Saving daily reminder success";
    } catch (e) {
      _message = "Failed to save daily reminder";
    }
    notifyListeners();
  }

  Future<void> setRandomRecommendation(bool isEnabled) async {
    try {
      _setting = _setting.copyWith(
        dailyReminder: _setting.dailyReminder.copyWith(
          isRandomRecommendation: isEnabled,
        ),
      );
      await _prefService.saveSettingValue(_setting);
      _message = "Saving daily reminder success";
    } catch (e) {
      _message = "Failed to save daily reminder";
    }
    notifyListeners();
  }

  Future<void> setReminderTime(TimeOfDay tod) async {
    try {
      _setting = _setting.copyWith(
        dailyReminder: _setting.dailyReminder.copyWith(
          time: tod,
        ),
      );
      await _prefService.saveSettingValue(_setting);
      _message = "Saving daily reminder success";
    } catch (e) {
      _message = "Failed to save daily reminder";
    }
    notifyListeners();
  }

  Future<void> setReminderContent(RestaurantNotification content) async {
    try {
      _setting = _setting.copyWith(
        dailyReminder: _setting.dailyReminder.copyWith(
          content: content,
        ),
      );
      await _prefService.saveSettingValue(_setting);
      _message = "Saving daily reminder success";
    } catch (e) {
      _message = "Failed to save daily reminder";
    }
    notifyListeners();
  }
}
