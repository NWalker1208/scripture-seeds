import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpSettings extends ChangeNotifier {
  static const String kHelp = 'showHelp.';

  bool get isLoaded => _showHelp != null;
  Map<String, bool> _showHelp;

  bool getShowHelp(String page) => (_showHelp != null) ? (_showHelp[page] ?? true) : false;

  void setShowHelp(String page, bool showHelp) {
    _showHelp[page] = showHelp;
    notifyListeners();

    // Set shared preferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(kHelp + page, showHelp);
    });
  }

  HelpSettings({bool defaultSetting = true}) {
    _showHelp = null;

    // Get shared preferences
    SharedPreferences.getInstance().then((prefs) {
      _showHelp = Map<String, bool>();
      Set<String> keys = prefs.getKeys();

      keys.where((key) => key.contains(kHelp)).forEach((key) {
        _showHelp[key.substring(kHelp.length)] = prefs.getBool(key);
      });

      notifyListeners();
    });
  }
}