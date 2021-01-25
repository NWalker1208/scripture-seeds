import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'database.dart';
import 'entry.dart';

class JournalProvider extends ChangeNotifier {
  JournalProvider(JournalDatabase database) : _database = database {
    _database.loadAllEntries().then((entries) {
      _entries = SplayTreeSet.of(entries);
      notifyListeners();
    });
  }

  final JournalDatabase _database;
  SplayTreeSet<JournalEntry> _entries;
  SplayTreeSet<String> _tagCache;

  /// Check if the database has been loaded.
  bool get isLoaded => _entries != null;

  /// Get all the entries stored in the journal.
  /// Sorted oldest to newest.
  Iterable<JournalEntry> get entries => _entries ?? const Iterable.empty();

  /// Get each tag that at least one entry has in its tag set.
  /// Sorted in alphabetical order.
  Iterable<String> get allTags {
    if (isLoaded) {
      _tagCache ??= SplayTreeSet.of(_entries.fold(
        Iterable.empty(),
        (p, e) => p.followedBy(e.tags),
      ));
      return _tagCache;
    }
    return const Iterable.empty();
  }

  /// Save a new journal entry.
  void save(JournalEntry entry) {
    _entries.add(entry);
    _database.saveEntry(entry);
    _tagCache?.addAll(entry.tags);
    notifyListeners();
  }

  /// Delete a journal entry. Returns true if successful.
  bool delete(JournalEntry entry) {
    if (!entries.contains(entry)) return false;

    _entries.remove(entry);
    _database.deleteEntry(entry);
    _tagCache = null; // Clear tag cache
    notifyListeners();

    return true;
  }

  /// Deletes all journal entries in the given iterable.
  void deleteCollection(Iterable<JournalEntry> entries) {
    for (var entry in entries) {
      if (!entries.contains(entry)) continue;
      _entries.remove(entry);
      _database.deleteEntry(entry);
    }

    _tagCache = null; // Clear tag cache
    notifyListeners();
  }

  /// Deletes every journal entry.
  void deleteAll() {
    _entries.clear();
    _database.clear();
    _tagCache = null; // Clear tag cache
    notifyListeners();
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }
}
