import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpSettings extends ChangeNotifier {
  static const String kHelp = 'showHelp.';

  bool get isLoaded => _showHelp != null;
  Map<String, bool> _showHelp;

  HelpSettings({bool defaultSetting = true}) {
    // Get shared preferences
    SharedPreferences.getInstance().then((prefs) {
      _showHelp = <String, bool>{};
      var keys = prefs.getKeys();

      keys.where((key) => key.contains(kHelp)).forEach((key) {
        _showHelp[key.substring(kHelp.length)] = prefs.getBool(key);
      });

      print('Help settings loaded!');
      notifyListeners();
    });
  }

  bool getShowHelp(String page) =>
      (_showHelp == null) ? null : (_showHelp[page] ?? true);

  void setShowHelp(String page, {bool showHelp}) {
    _showHelp[page] = showHelp;
    notifyListeners();

    // Set shared preferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(kHelp + page, showHelp);
    });
  }

  void resetHelp() {
    _showHelp.clear();
    notifyListeners();

    // Delete from shared prefs
    SharedPreferences.getInstance().then((prefs) {
      var keys = prefs.getKeys();
      for (var key in keys.where((key) => key.contains(kHelp))) {
        prefs.remove(key);
      }
    });
  }
}
