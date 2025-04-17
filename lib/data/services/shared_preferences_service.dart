import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/model/user_profile.dart';

class SharedPreferencesService {
  final SharedPreferencesAsync _preferences;

  SharedPreferencesService(this._preferences);
  static const String keyUser = "STORY_APP_USER";
  static const String keySetting = "STORY_APP_SETTING";

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

  Future<UserProfile?> getUserValue() async {
    try {
      final userString = await _preferences.getString(keyUser);
      final userJson = jsonDecode("$userString");
      return userJson != null ? UserProfile.fromJson(userJson) : null;
    } catch (e) {
      throw Exception("can't get shared preferences");
    }
  }

  Future<void> removeUserValue() async {
    try {
      await _preferences.remove(keyUser);
    } catch (e) {
      throw Exception("can't remove shared preferences");
    }
  }
}
  

  // Future<void> saveSettingValue(Setting setting) async {
  //   try {
  //     String settingString = jsonEncode(setting.toJson());
  //     await _preferences.setString(
  //       keySetting,
  //       settingString,
  //     );
  //   } catch (e) {
  //     throw Exception("can't save shared preferences");
  //   }
  // }

  // Setting getSettingValue() {
  //   final settingString = _preferences.getString(keySetting);
  //   final settingJson = jsonDecode("$settingString");
  //   return Setting.fromJson(settingJson);
  // }

