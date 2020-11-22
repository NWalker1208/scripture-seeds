import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seeds/services/library/study_resource.dart';

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

  JournalEntry({DateTime created, this.category = Category.Other,
                this.quote = '', this.reference = '',
                this.url = '', this.commentary = '', List<String> tags})
   : this.created = created ?? DateTime.now(),
     this.tags = tags ?? List<String>();

  JournalEntry.fromJSON(String json) {
    Map<String, dynamic> data = jsonDecode(json);

    created = data.containsKey(_kFileCreated) ?
      DateTime.parse(data[_kFileCreated]) : null;

    category = Category.parse(data[_kFileCategory]);
    quote = data[_kFileQuote] ?? data[_kFileReference] ?? '';
    reference = data[_kFileReference] ?? '';
    url = data[_kFileURL] ?? '';
    commentary = data[_kFileCommentary] ?? '';

    tags = data.containsKey(_kFileTags) ?
      List<String>.from(data[_kFileTags]) : List<String>();
  }

  String toJSON() {
    Map<String, dynamic> data = Map<String, dynamic>();
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
    if (quote != reference)
      return '$quote - $reference\n$commentary\n$url';
    else
      return '$quote\n$commentary';
  }

  String get fileName {
    return created.toIso8601String().replaceAll(RegExp(r'[:.]'), '_') +
      _kEntryFileExtension;
  }

  @override
  int compareTo(JournalEntry other) {
    return created.compareTo(other.created);
  }
}

class JournalData extends ChangeNotifier {
  List<JournalEntry> _entries;

  JournalData() {
    _loadEntries().then((List<JournalEntry> entries) {
      _entries = entries;
      _entries.sort();
      notifyListeners();
    });
  }

  bool get isLoaded => _entries != null;
  List<JournalEntry> get entries => _entries?.toList() ?? <JournalEntry>[];

  Set<String> get topics {
    Set<String> _topics = Set<String>();
    entries.forEach((entry) => _topics.addAll(entry.tags));
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
    entriesToDelete.forEach((entry) {
      _entries.remove(entry);
      _deleteEntry(entry);
    });

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
      Directory appDocDir = await getApplicationDocumentsDirectory();
      Directory journalFolder = Directory(appDocDir.path + _kJournalFolder)
        ..createSync(recursive: true);

      List<FileSystemEntity> entryFiles = journalFolder.listSync();

      List<JournalEntry> entries = List<JournalEntry>();
      entryFiles.forEach((entity) {
        if (entity is File) {
          try {
            JournalEntry entry = JournalEntry.fromJSON(entity.readAsStringSync());
            entries.add(entry);
          } on FormatException {
            print('Encountered invalid journal entry at ${entity.path}, deleting...');
            entity.delete();
          }
        }
      });

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
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File entryFile = File(appDocDir.path + _kJournalFolder + entry.fileName);
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
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File entryFile = File(appDocDir.path + _kJournalFolder + entry.fileName);
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
      Directory appDocDir = await getApplicationDocumentsDirectory();
      Directory journalFolder = Directory(appDocDir.path + _kJournalFolder);
      journalFolder.deleteSync(recursive: true);

      print('Journal erased.');
      return true;
    } on FileSystemException catch (e) {
      print('File system exception while erasing journal: $e');
      return false;
    }
  }
}