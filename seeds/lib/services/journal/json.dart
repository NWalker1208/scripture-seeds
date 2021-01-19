import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../custom_database/file.dart';
import 'database.dart';
import 'entry.dart';

const String _journalFolder = 'study_journal';

class JsonJournalDatabase extends JournalDatabase<Directory>
    with CustomFileDatabase<String, JournalEntry> {
  @override
  Future<Directory> get directory async => Directory(path.join(
        (await getApplicationDocumentsDirectory()).path,
        _journalFolder,
      )).create(recursive: true);

  @override
  String get extension => '.jrnent';

  @override
  String keyToFilename(String key) => key;

  @override
  String writeValue(JournalEntry value) => jsonEncode(value.toJson());

  @override
  String filenameToKey(String file) => file;

  @override
  JournalEntry parseValue(String str) =>
      JournalEntry.fromJson(jsonDecode(str) as Map<String, dynamic>);

}
