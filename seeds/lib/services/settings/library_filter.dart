import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../library/study_resource.dart';

class LibraryFilter extends ChangeNotifier {
  static const String kCategoryPref = 'study_category_';

  Map<Category, bool> _filter;

  LibraryFilter() {
    _filter = <Category, bool>{};
    for (var category in Category.values) {
      _filter[category] = true;
    }

    // Get shared preferences
    SharedPreferences.getInstance().then((prefs) {
      for (var category in Category.values) {
        _filter[category] = prefs.getBool('$kCategoryPref$category') ?? true;
      }

      notifyListeners();
    });
  }

  bool operator [](Category c) => _filter[c];

  void operator []=(Category c, bool val) {
    if (val != _filter[c]) {
      _filter[c] = val;
      notifyListeners();

      // Set shared preferences
      SharedPreferences.getInstance()
          .then((prefs) => prefs.setBool('$kCategoryPref$c', val));
    }
  }
}
