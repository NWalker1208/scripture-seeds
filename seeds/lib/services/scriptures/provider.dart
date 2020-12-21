import 'package:flutter/foundation.dart';

import 'database.dart';

class ScriptureProvider extends ChangeNotifier {
  final ScriptureDatabase database;

  ScriptureProvider(this.database) {
    notifyListeners();
  }
}
