import 'package:flutter/foundation.dart';

import '../scriptures/reference.dart';
import 'database.dart';

class StudyHistory extends ChangeNotifier {
  StudyHistory(
    HistoryDatabase database, {
    Duration maxAge = const Duration(days: 30),
  }) : _database = database {
    _database.loadAll().then((history) {
      _history = history;
      notifyListeners();
      deleteOld(DateTime.now().subtract(maxAge));
    });
  }

  final HistoryDatabase _database;
  Map<ScriptureReference, DateTime> _history;

  /// Check if the database has been loaded.
  bool get isLoaded => _history != null;

  /// Get list of all references in history.
  List<ScriptureReference> get references => _history?.keys?.toList();

  /// Gets the date last studied for a library resource.
  /// Returns null if never studied or if history is not loaded.
  DateTime lastStudied(ScriptureReference reference) {
    if (!isLoaded || !_history.containsKey(reference)) return null;
    return _history[reference];
  }

  /// Updates the history of a library resource to show studied on date.
  /// If no date is given, the current time is used.
  /// Returns false if history has not finished loading.
  bool markStudied(ScriptureReference reference, {DateTime date}) {
    if (!isLoaded) return false;

    _history[reference] = date ?? DateTime.now();
    _database.save(reference, _history[reference]);
    notifyListeners();

    return true;
  }

  /// Deletes history that occurred prior to date.
  int deleteOld(DateTime date) {
    if (!isLoaded) return 0;

    final oldEntries = _history.entries.where((e) => e.value.isBefore(date));
    for (var entry in oldEntries) {
      _history.remove(entry.key);
      _database.delete(entry.key);
    }
    if (oldEntries.isNotEmpty) notifyListeners();

    return oldEntries.length;
  }

  /// Deletes all history entries
  bool clear() {
    if (isLoaded) {
      _history.clear();
      _database.clear();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }
}
