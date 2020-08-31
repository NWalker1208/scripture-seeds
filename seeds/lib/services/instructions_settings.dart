import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstructionsSettings extends ChangeNotifier {
  static const String kInstructions = 'showInstructions';

  bool _alwaysShow;
  bool get alwaysShow => _alwaysShow;

  set alwaysShow(bool alwaysShow) {
    _alwaysShow = alwaysShow;
    notifyListeners();

    // Set shared preferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(kInstructions, _alwaysShow);
    });
  }

  InstructionsSettings({bool defaultSetting = true}) {
    _alwaysShow = defaultSetting;

    // Get shared preferences
    SharedPreferences.getInstance().then((prefs) {
      _alwaysShow = prefs.getBool(kInstructions) ?? defaultSetting;
      notifyListeners();
    });
  }
}