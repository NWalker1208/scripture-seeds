import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../library/study_resource.dart';
import '../utility.dart';

const String _kJournalFolder = '/study_journal/';
const String _kEntryFileExtension = '.jrnent';

const String _kFileCreated = 'created';
const String _kFileCategory = 'category';
const String _kFileQuote = 'quote';
const String _kFileReference = 'reference';
const String _kFileURL = 'url';
const String _kFileCommentary = 'commentary';
const String _kFileTags = 'tags';

class JournalEntry implements Comparable<JournalEntry> {
  DateTime created;
  Category category;
  String quote;
  String reference;
  String url;
  String commentary;
  List<String> tags;

  JournalEntry({
    DateTime created,
    this.category = Category.other,
    this.quote = '',
    this.reference = '',
    this.url = '',
    this.commentary = '',
    List<String> tags,
  })  : created = created ?? DateTime.now(),
        tags = tags ?? <String>[];

  JournalEntry.fromJSON(String json) {
    var data = jsonDecode(json) as Map<String, dynamic>;

    created = data.containsKey(_kFileCreated)
        ? DateTime.parse(data[_kFileCreated] as String)
        : null;

    category = (data[_kFileCategory] as String).toEnum(Category.values);
    quote = (data[_kFileQuote] ?? data[_kFileReference]) as String ?? '';
    reference = data[_kFileReference] as String ?? '';
    url = data[_kFileURL] as String ?? '';
    commentary = data[_kFileCommentary] as String ?? '';

    tags = data.containsKey(_kFileTags)
        ? (data[_kFileTags] as List<dynamic>).whereType<String>().toList()
        : <String>[];
  }

  String toJSON() {
    var data = <String, dynamic>{};
    data[_kFileCreated] = created.toString();
    data[_kFileCategory] = category.toString();
    data[_kFileQuote] = quote;
    data[_kFileReference] = reference;
    data[_kFileURL] = url;
    data[_kFileCommentary] = commentary;
    data[_kFileTags] = tags;
    return jsonEncode(data);
  }

  @override
  String toString() {
    if (quote != reference) {
      return '$quote - $reference\n$commentary\n$url';
    } else {
      return '$quote\n$commentary';
    }
  }

  String get fileName =>
      created.toIso8601String().replaceAll(RegExp(r'[:.]'), '_') +
      _kEntryFileExtension;

  @override
  int compareTo(JournalEntry other) => created.compareTo(other.created);
}

class JournalData extends ChangeNotifier {
  List<JournalEntry> _entries;

  JournalData() {
    _loadEntries().then((entries) {
      _entries = entries;
      _entries.sort();
      notifyListeners();
    });
  }

  bool get isLoaded => _entries != null;
  List<JournalEntry> get entries => _entries?.toList() ?? <JournalEntry>[];

  Set<String> get topics {
    var _topics = <String>{};
    for (var entry in entries) {
      _topics.addAll(entry.tags);
    }
    return _topics;
  }

  void createEntry(JournalEntry entry) {
    _entries.add(entry);
    _entries.sort();
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

  static Future<List<JournalEntry>> _loadEntries() async {
    print('Loading journal entries...');

    try {
      var appDocDir = await getApplicationDocumentsDirectory();
      var journalFolder = Directory(appDocDir.path + _kJournalFolder)
        ..createSync(recursive: true);

      var entryFiles = journalFolder.listSync();

      var entries = <JournalEntry>[];
      for (var entity in entryFiles) {
        if (entity is File) {
          try {
            var entry = JournalEntry.fromJSON(entity.readAsStringSync());
            entries.add(entry);
          } on FormatException {
            print(
              'Encountered invalid journal entry at ${entity.path}, deleting...',
            );
            await entity.delete();
          }
        }
      }

      print('Journal entries loaded!');
      return entries;
    } on FileSystemException catch (e) {
      print('File system exception while loading journal: $e');
      return null;
    }
  }

  static Future<bool> _saveNewEntry(JournalEntry entry) async {
    print('Saving new entry to journal...');

    try {
      var appDocDir = await getApplicationDocumentsDirectory();
      var entryFile = File(appDocDir.path + _kJournalFolder + entry.fileName);
      entryFile.writeAsStringSync(entry.toJSON());

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
      var appDocDir = await getApplicationDocumentsDirectory();
      var entryFile = File(appDocDir.path + _kJournalFolder + entry.fileName);
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
      var appDocDir = await getApplicationDocumentsDirectory();
      var journalFolder = Directory(appDocDir.path + _kJournalFolder);
      journalFolder.deleteSync(recursive: true);

      print('Journal erased.');
      return true;
    } on FileSystemException catch (e) {
      print('File system exception while erasing journal: $e');
      return false;
    }
  }
}
