import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> get _instance async {
    _prefsInstance ??= await SharedPreferences.getInstance();
    return _prefsInstance!;
  }

  static Future<void> init() async {
    await _instance;
  }

  static String? getString(String key, [String? defValue]) {
    return _prefsInstance?.getString(key) ?? defValue;
  }

  static Future<bool> setString(String key, String value) async {
    final prefs = await _instance;
    return prefs.setString(key, value);
  }

  static bool? getBool(String key, [bool? defValue]) {
    return _prefsInstance?.getBool(key) ?? defValue;
  }

  static Future<bool> setBool(String key, bool value) async {
    final prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static int? getInt(String key, [int? defValue]) {
    return _prefsInstance?.getInt(key) ?? defValue;
  }

  static Future<bool> setInt(String key, int value) async {
    final prefs = await _instance;
    return prefs.setInt(key, value);
  }

  static Future<bool> remove(String key) async {
    final prefs = await _instance;
    return prefs.remove(key);
  }

  static List<String> getStringList(String key) {
    return _prefsInstance?.getStringList(key) ?? [];
  }

  static Future<Future<bool>> setStringList(String key, List<String> defValue) async {
    final prefs = await _instance;
    return prefs.setStringList(key, defValue);
  }

  static Future<bool> ensureFreshInstallLogout() async {
    final prefs = await _instance;
    const installedKey = 'app_installed';
    if (!prefs.containsKey(installedKey)) {
      await prefs.setBool(installedKey, true);
      return true;
    }
    return false;
  }
}
