import 'package:flutter/foundation.dart';

import 'database.dart';
import 'entry.dart';

class JournalProvider extends ChangeNotifier {
  JournalProvider(JournalDatabase database) : _database = database {
    _database.loadAllEntries().then((entries) {
      _entries = entries.toList()..sort();
      notifyListeners();
    });
  }

  final JournalDatabase _database;
  List<JournalEntry> _entries;

  /// Check if the database has been loaded.
  bool get isLoaded => _entries != null;

  /// Get all the entries stored in the journal.
  /// Sorted oldest to newest.
  Iterable<JournalEntry> get entries => _entries ?? const [];

  /// Get each tag that at least one entry has in its tag set.
  Iterable<String> get allTags =>
      isLoaded ? {for (var e in _entries) ...e.tags} : const {};

  /// Save a new journal entry.
  void save(JournalEntry entry) {
    _entries.add(entry);
    _entries.sort();
    _database.saveEntry(entry);
    notifyListeners();
  }

  /// Delete a journal entry. Returns true if successful.
  bool delete(JournalEntry entry) {
    if (!entries.contains(entry)) return false;

    _entries.remove(entry);
    _database.deleteEntry(entry);
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

    notifyListeners();
  }

  /// Deletes every journal entry.
  void deleteAll() {
    _entries.clear();
    _database.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  // static Future<List<JournalEntry>> _loadEntries() async {
  //   print('Loading journal entries...');
  //
  //   try {
  //     var entryFiles = (await _journalFolder).listSync();
  //
  //     var entries = <JournalEntry>[];
  //     for (var entity in entryFiles) {
  //       if (entity is File) {
  //         try {
  //           var entry = JournalEntry.fromJson(
  //               jsonDecode(entity.readAsStringSync()) as Map<String, dynamic>);
  //           entries.add(entry);
  //         } on FormatException {
  //           print(
  //             'Encountered invalid journal entry ${entity.path}, deleting...',
  //           );
  //           await entity.delete();
  //         } on Exception catch (e) {
  //           print(
  //             'Unknown exception occurred while reading '
  //             'journal entry ${entity.path}: $e',
  //           );
  //         }
  //       }
  //     }
  //
  //     print('Loaded ${entries.length} journal entries!');
  //     return entries;
  //   } on FileSystemException catch (e) {
  //     print('File system exception while loading journal: $e');
  //     return null;
  //   }
  // }
}
