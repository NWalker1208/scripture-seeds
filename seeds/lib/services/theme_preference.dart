import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference extends ChangeNotifier {
  static const String kThemePref = 'theme';

  ThemeMode _mode;
  ThemeMode get mode => _mode;

  set mode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();

    // Set shared preferences
    SharedPreferences.getInstance().then((prefs) {
      int savedMode;

      if (_mode == ThemeMode.system)
        savedMode = 0;
      else if (_mode == ThemeMode.light)
        savedMode = 1;
      else if (_mode == ThemeMode.dark)
        savedMode = 2;

      prefs.setInt(kThemePref, savedMode);
    });
  }

  ThemePreference({ThemeMode defaultMode = ThemeMode.system}) {
    _mode = defaultMode;

    // Get shared preferences
    SharedPreferences.getInstance().then((prefs) {
      int savedMode = prefs.getInt(kThemePref) ?? -1;

      if (savedMode == 0)
        _mode = ThemeMode.system;
      else if (savedMode == 1)
        _mode = ThemeMode.light;
      else if (savedMode == 2)
        _mode = ThemeMode.dark;

      notifyListeners();
    });
  }
}
