import 'package:flutter/foundation.dart';

import 'database.dart';
import 'library.dart';

class ScriptureProvider extends ChangeNotifier {
  final ScriptureDatabase database;

  ScriptureLibrary _library;
  ScriptureLibrary get library => _library;

  ScriptureProvider(this.database) {
    database.loadLibrary().then((value) {
      _library = value;
      print('Loaded scripture library with '
          '${_library.chapterCount} chapters and '
          '${_library.verseCount} verses');
      notifyListeners();
    });
  }
}
