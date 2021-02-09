import '../provider.dart';
import '../scriptures/reference.dart';
import 'database.dart';

class HistoryProvider extends ServiceProvider<HistoryDatabase> {
  HistoryProvider(
    HistoryDatabase Function() create, {
    this.maxAge = const Duration(days: 30),
  }) : super(create);

  final Duration maxAge;
  Map<ScriptureReference, DateTime> _history;

  /// Oldest date allowable for history entries to be kept.
  DateTime get minimumDate => DateTime.now().subtract(maxAge);

  /// Get list of all references in history.
  Iterable<ScriptureReference> get references => _history?.keys;

  /// Gets the date last studied for a library resource.
  /// Returns null if never studied or if history is not loaded.
  DateTime lastStudied(ScriptureReference reference) {
    if (!isLoaded || !_history.containsKey(reference)) return null;
    return _history[reference];
  }

  /// Updates the history of a library resource to show studied on date.
  /// If no date is given, the current time is used.
  /// Returns false if unable to add, or if date is too old.
  bool markStudied(ScriptureReference reference, {DateTime date}) {
    if (!isLoaded) return false;
    date ??= DateTime.now();
    if (date.isBefore(minimumDate)) {
      _history.remove(reference);
      notifyService((data) => data.remove(reference));
      return false;
    } else {
      _history[reference] = date;
      notifyService((data) => data.save(reference, date));
      return true;
    }
  }

  /// Deletes all history entries
  void clear() {
    if (!isLoaded) return;
    _history.clear();
    notifyService((data) => data.clear());
  }

  @override
  Future<void> loadData(HistoryDatabase data) async {
    _history = await data.loadAll();
    // Delete old records before finishing
    final date = minimumDate;
    for (var entry in _history.entries.where((e) => e.value.isBefore(date))) {
      _history.remove(entry.key);
      await data.remove(entry.key);
    }
  }
}
