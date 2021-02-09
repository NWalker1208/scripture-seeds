import 'dart:collection';

import '../provider.dart';
import 'database.dart';
import 'entry.dart';

class JournalProvider extends ServiceProvider<JournalDatabase> {
  JournalProvider(JournalDatabase Function() create) : super(create);

  SplayTreeSet<JournalEntry> _entries;
  SplayTreeSet<String> _tagCache;

  /// Get all the entries stored in the journal.
  /// Sorted oldest to newest.
  Iterable<JournalEntry> get entries => _entries ?? const Iterable.empty();

  /// Get each tag that at least one entry has in its tag set.
  /// Sorted in alphabetical order.
  Iterable<String> get allTags {
    if (!isLoaded) return const Iterable.empty();
    return _tagCache ??= SplayTreeSet.of({
      for (var entry in _entries) ...entry.tags,
    });
  }

  /// Save a new journal entry.
  void save(JournalEntry entry) {
    _tagCache?.addAll(entry.tags);
    _entries.add(entry);
    notifyService((data) => data.saveEntry(entry));
  }

  /// Delete a journal entry. Returns true if successful.
  bool delete(JournalEntry entry) {
    if (!entries.contains(entry)) return false;

    _tagCache = null; // Clear tag cache
    _entries.remove(entry);
    notifyService((data) => data.removeEntry(entry));

    return true;
  }

  /// Deletes all journal entries in the given iterable.
  void deleteCollection(Iterable<JournalEntry> entries) {
    _tagCache = null; // Clear tag cache
    _entries.removeAll(entries);
    notifyService((data) => Future.wait([
          for (var entry in entries) data.removeEntry(entry),
        ]));
  }

  /// Deletes every journal entry.
  void deleteAll() {
    _tagCache = SplayTreeSet();
    _entries.clear();
    notifyService((data) => data.clear());
  }

  @override
  Future<void> loadData(JournalDatabase data) async {
    _entries = SplayTreeSet.of(await data.loadAllEntries());
  }
}
