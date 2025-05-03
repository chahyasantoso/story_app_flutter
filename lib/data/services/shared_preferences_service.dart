import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/model/settings.dart';
import 'package:story_app/data/model/user_profile.dart';

class SharedPreferencesService {
  final SharedPreferencesAsync _preferences;

  SharedPreferencesService(this._preferences);
  static const String keyUser = "STORY_APP_USER";
  static const String keySetting = "STORY_APP_SETTING";

  Future<void> saveUserValue(UserProfile user) async {
    String userString = jsonEncode(user.toJson());
    await _preferences.setString(
      keyUser,
      userString,
    );
  }

  Future<UserProfile?> getUserValue() async {
    final userString = await _preferences.getString(keyUser);
    final userJson = jsonDecode("$userString");
    return userJson != null ? UserProfile.fromJson(userJson) : null;
  }

  Future<void> removeUserValue() async {
    await _preferences.remove(keyUser);
  }

  Future<void> saveSettingValue(Settings setting) async {
    String settingString = jsonEncode(setting.toJson());
    await _preferences.setString(
      keySetting,
      settingString,
    );
  }

  Future<Settings?> getSettingValue() async {
    final settingString = await _preferences.getString(keySetting);
    final settingJson = jsonDecode("$settingString");
    return settingJson != null ? Settings.fromJson(settingJson) : null;
  }
}
