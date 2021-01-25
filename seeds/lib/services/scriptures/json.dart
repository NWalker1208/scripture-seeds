import 'dart:convert';

import 'package:flutter/services.dart';

import 'books.dart';
import 'database.dart';
import 'verse.dart';

const String _jsonAsset = 'assets/lds-scriptures/json/lds-scriptures-json.txt';

const String _bookTitle = 'book_title';
const String _chapterNumber = 'chapter_number';
const String _verseNumber = 'verse_number';
const String _verseText = 'scripture_text';

class JsonScriptureDatabase
    extends ScriptureDatabase<Map<ScriptureVerse, String>> {
  JsonScriptureDatabase({AssetBundle assets}) : _assets = assets ?? rootBundle;

  final AssetBundle _assets;

  @override
  Future<Map<ScriptureVerse, String>> open() async {
    final jsonStr = await _assets.loadString(_jsonAsset);
    return {
      for (var verseJson in jsonDecode(jsonStr) as List<dynamic>)
        if (verseJson is Map<String, dynamic>)
          ScriptureVerse(
            parseBook(verseJson[_bookTitle] as String),
            verseJson[_chapterNumber] as int,
            verseJson[_verseNumber] as int,
          ): verseJson[_verseText] as String,
    };
  }

  @override
  Future<int> getChapterCount(Book book) async {
    final db = await data;
    return db.keys.where((v) => v.book == book && v.number == 1).length;
  }

  @override
  Future<int> getVerseCount(Book book, int chapter) async {
    final db = await data;
    return db.keys.where((v) => v.book == book && v.chapter == chapter).length;
  }

  @override
  Future<String> load(ScriptureVerse key) async {
    final db = await data;
    return db[key];
  }
}
