import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const String _kJournalFolder = '/study_journal/';
const String _kEntryFileExtension = '.jrnent';

const String _kFileCreated = 'created';
const String _kFileReference = 'reference';
const String _kFileCommentary = 'commentary';
const String _kFileTags = 'tags';

class JournalEntry {
  DateTime created;
  String reference;
  String commentary;
  List<String> tags;

  JournalEntry({DateTime created, this.reference = '', this.commentary = '', List<String> tags})
   : this.created = created ?? DateTime.now(),
     this.tags = tags ?? List<String>();

  JournalEntry.fromJSON(String json) {
    Map<String, dynamic> data = jsonDecode(json);

    created = data.containsKey(_kFileCreated) ?
      DateTime.parse(data[_kFileCreated]) : null;

    reference = data[_kFileReference] ?? '';
    commentary = data[_kFileCommentary] ?? '';

    tags = data.containsKey(_kFileTags) ?
      List<String>.from(data[_kFileTags]) : List<String>();
  }

  String toJSON() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data[_kFileCreated] = created.toString();
    data[_kFileReference] = reference;
    data[_kFileCommentary] = commentary;
    data[_kFileTags] = tags;
    return jsonEncode(data);
  }

  String get fileName {
    return created.toIso8601String().replaceAll(RegExp(r'[:.]'), '_') +
      _kEntryFileExtension;
  }
}

class JournalData extends ChangeNotifier {
  List<JournalEntry> _entries;

  JournalData() {
    _loadEntries().then((List<JournalEntry> entries) {
      _entries = entries;
      notifyListeners();
    });
  }

  bool get isLoaded => _entries != null;
  List<JournalEntry> get entries => _entries ?? List<JournalEntry>();

  void createEntry(JournalEntry entry) {
    _entries.add(entry);
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
