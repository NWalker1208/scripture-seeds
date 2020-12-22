import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../scriptures/volumes.dart';

class StudyFilter extends ChangeNotifier {
  static const String kCategoryPref = 'study_';

  Map<Volume, bool> _filter;

  StudyFilter() {
    _filter = <Volume, bool>{};
    for (var volume in Volume.values) {
      _filter[volume] = true;
    }

    // Get shared preferences
    SharedPreferences.getInstance().then((prefs) {
      for (var volume in Volume.values) {
        _filter[volume] = prefs.getBool('$kCategoryPref$volume') ?? true;
      }

      notifyListeners();
    });
  }

  bool operator [](Volume volume) => _filter[volume];

  void operator []=(Volume volume, bool enabled) {
    if (enabled != _filter[volume]) {
      _filter[volume] = enabled;
      notifyListeners();

      // Set shared preferences
      SharedPreferences.getInstance()
          .then((prefs) => prefs.setBool('$kCategoryPref$volume', enabled));
    }
  }
}
