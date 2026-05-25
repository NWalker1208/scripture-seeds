import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const String _themePref = 'theme';

  final ThemeMode defaultMode;
  final Future<SharedPreferences> _preferences;

  ThemePreferences({this.defaultMode = ThemeMode.system})
      : _preferences = SharedPreferences.getInstance();

  Future<ThemeMode> getPreferredTheme() async {
    var prefs = await _preferences;
    var savedMode = prefs.getInt(_themePref) ?? -1;

    if (savedMode == 0) {
      return ThemeMode.system;
    } else if (savedMode == 1) {
      return ThemeMode.light;
    } else if (savedMode == 2) {
      return ThemeMode.dark;
    }

    return defaultMode;
  }

  Future<void> setPreferredTheme(ThemeMode mode) async {
    var prefs = await _preferences;
    int savedMode;

    if (mode == ThemeMode.system) {
      savedMode = 0;
    } else if (mode == ThemeMode.light) {
      savedMode = 1;
    } else {
      savedMode = 2;
    }

    await prefs.setInt(_themePref, savedMode);
  }
}
