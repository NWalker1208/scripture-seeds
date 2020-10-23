import 'package:flutter/material.dart';
import 'package:seeds/services/library/study_resource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryFilter extends ChangeNotifier {
  static const String kCategoryPref = 'study_category_';

  Map<Category, bool> _filter;

  LibraryFilter() {
    _filter = Map<Category, bool>();
    Category.values.forEach((category) => _filter[category] = true);

    // Get shared preferences
    SharedPreferences.getInstance().then((prefs) {
      Category.values.forEach((category) =>
        _filter[category] = prefs.getBool('$kCategoryPref$category') ?? true
      );

      notifyListeners();
    });
  }

  operator [](Category c) => _filter[c];

  operator []=(Category c, bool val) {
    if (val != _filter[c]) {
      _filter[c] = val;
      notifyListeners();

      // Set shared preferences
      SharedPreferences.getInstance().then((prefs) =>
        prefs.setBool('$kCategoryPref$c', val)
      );
    }
  }
}
