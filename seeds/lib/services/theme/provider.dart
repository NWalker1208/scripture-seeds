import 'package:flutter/material.dart';

import 'data.dart';
import 'preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemePreferences _preferences;
  CustomThemeData _themeData;

  ThemeMode _mode;

  ThemeProvider({ThemeMode defaultMode = ThemeMode.system})
      : _preferences = ThemePreferences(defaultMode: defaultMode) {
    _mode = defaultMode;
    refresh();
  }

  ThemeMode get mode => _mode;
  set mode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
    _preferences.setPreferredTheme(mode);
  }

  ThemeData get light => _themeData.light;
  ThemeData get dark => _themeData.dark;

  void refresh() {
    _themeData = CustomThemeData();
    notifyListeners();

    _preferences.getPreferredTheme().then((mode) {
      _mode = mode;
      print('Using $mode');
      notifyListeners();
    });
  }
}
