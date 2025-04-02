import 'dart:convert';

import 'package:restaurant_app/data/model/setting.dart';
import 'package:restaurant_app/data/model/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String keySetting = "RESTAURANT_APP_SETTING";
  static const String keyUser = "RESTAURANT_APP_USER";

  Future<void> saveUserValue(UserProfile user) async {
    try {
      String userString = jsonEncode(user.toJson());
      await _preferences.setString(
        keyUser,
        userString,
      );
    } catch (e) {
      throw Exception("can't save shared preferences");
    }
  }

  UserProfile getUserValue() {
    final userString = _preferences.getString(keyUser);
    final userJson = jsonDecode("$userString");
    return UserProfile.fromJson(userJson);
  }

  Future<void> saveSettingValue(Setting setting) async {
    try {
      String settingString = jsonEncode(setting.toJson());
      await _preferences.setString(
        keySetting,
        settingString,
      );
    } catch (e) {
      throw Exception("can't save shared preferences");
    }
  }

  Setting getSettingValue() {
    final settingString = _preferences.getString(keySetting);
    final settingJson = jsonDecode("$settingString");
    return Setting.fromJson(settingJson);
  }
}
