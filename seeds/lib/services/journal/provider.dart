import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'entry.dart';

const String _kJournalFolder = '/study_journal/';

class JournalData extends ChangeNotifier {
  List<String> _topics;
  List<JournalEntry> _entries;

  JournalData() {
    _loadEntries().then((entries) {
      _entries = entries..sort();
      _topics = <String>{for (var e in _entries) ...e.tags}.toList()..sort();
      notifyListeners();
    });
  }

  bool get isLoaded => _entries != null;
  List<JournalEntry> get entries => _entries?.toList() ?? <JournalEntry>[];
  List<String> get topics => _topics?.toList() ?? <String>[];

  void createEntry(JournalEntry entry) {
    _entries.add(entry);
    _entries.sort();
    _topics = (_topics.toSet()..addAll(entry.tags)).toList()..sort();
    notifyListeners();

    _saveNewEntry(entry);
  }

  void deleteEntry({JournalEntry entry, int index}) {
    if (entry != null && _entries.contains(entry)) {
      _entries.remove(entry);
      notifyListeners();

      _deleteEntry(entry);
    } else if (index != null) {
      entry = _entries[index];
      _entries.removeAt(index);
      notifyListeners();

      _deleteEntry(entry);
    }
  }

  void deleteEntrySet(Set<JournalEntry> entriesToDelete) {
    for (var entry in entriesToDelete) {
      _entries.remove(entry);
      _deleteEntry(entry);
    }

    notifyListeners();
  }

  void deleteAllEntries() {
    _entries.clear();
    notifyListeners();

    _eraseJournal();
  }

  /// File system backend
  static Future<Directory> get _journalFolder async => Directory(
          (await getApplicationDocumentsDirectory()).path + _kJournalFolder)
      .create(recursive: true);

  static Future<List<JournalEntry>> _loadEntries() async {
    print('Loading journal entries...');

    try {
      var entryFiles = (await _journalFolder).listSync();

      var entries = <JournalEntry>[];
      for (var entity in entryFiles) {
        if (entity is File) {
          try {
            var entry = JournalEntry.fromJson(
                jsonDecode(entity.readAsStringSync()) as Map<String, dynamic>);
            entries.add(entry);
          } on FormatException {
            print(
              'Encountered invalid journal entry ${entity.path}, deleting...',
            );
            await entity.delete();
          } on Exception catch (e) {
            print(
              'Unknown exception occurred while reading '
              'journal entry ${entity.path}: $e',
            );
          }
        }
      }

      print('Loaded ${entries.length} journal entries!');
      return entries;
    } on FileSystemException catch (e) {
      print('File system exception while loading journal: $e');
      return null;
    }
  }

  static Future<bool> _saveNewEntry(JournalEntry entry) async {
    print('Saving new entry to journal...');

    try {
      var entryFile = File((await _journalFolder).path + entry.fileName);
      entryFile.writeAsStringSync(jsonEncode(entry.toJSON()));

      print('Entry saved.');
      return true;
    } on FileSystemException catch (e) {
      print('File system exception while saving new entry: $e');
      return false;
    }
  }

  static Future<bool> _deleteEntry(JournalEntry entry) async {
    print('Deleting entry from journal...');

    try {
      var entryFile = File((await _journalFolder).path + entry.fileName);
      entryFile.deleteSync();

      print('Entry deleted.');
      return true;
    } on FileSystemException catch (e) {
      print('File system exception while deleting entry: $e');
      return false;
    }
  }

  static Future<bool> _eraseJournal() async {
    print('Erasing all journal entries...');

    try {
      (await _journalFolder).deleteSync(recursive: true);

      print('Journal erased.');
      return true;
    } on FileSystemException catch (e) {
      print('File system exception while erasing journal: $e');
      return false;
    }
  }
}
