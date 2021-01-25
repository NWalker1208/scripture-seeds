import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'books.dart';
import 'database.dart';
import 'verse.dart';

// Database Schema
const String _bookTable = 'books';
const String _bookId = 'id';
const String _bookTitle = 'book_title';

const String _chapterTable = 'chapters';
const String _chapterId = 'id';
const String _chapterBook = 'book_id';
const String _chapterNumber = 'chapter_number';

const String _verseTable = 'verses';
const String _verseId = 'id';
const String _verseChapter = 'chapter_id';
const String _verseNumber = 'verse_number';
const String _verseText = 'scripture_text';

const String _databaseAsset =
    'assets/lds-scriptures/sqlite/lds-scriptures-sqlite.db';

class SqlScriptureDatabase extends ScriptureDatabase<Database> {
  SqlScriptureDatabase({AssetBundle assets}) : _assets = assets ?? rootBundle;

  final AssetBundle _assets;

  @override
  Future<Database> open() async {
    var file = await _createTempDatabaseCopy();
    return openDatabase(file.path);
  }

  @override
  Future<int> getChapterCount(Book book) async {
    var db = await data;
    var chapters = await db.query(
      _chapterTable,
      where: '$_chapterBook=?',
      whereArgs: <dynamic>[await _getBookId(book)],
    );

    return chapters.length;
  }

  @override
  Future<int> getVerseCount(Book book, int chapter) async {
    var db = await data;
    var verses = await db.query(
      _verseTable,
      where: '$_verseChapter=?',
      whereArgs: <dynamic>[await _getChapterId(book, chapter)],
    );

    return verses.length;
  }

  @override
  Future<String> load(ScriptureVerse verse) async {
    var db = await data;
    final text = (await db.query(
      _verseTable,
      columns: [_verseText],
      where: '$_verseId=?',
      whereArgs: <dynamic>[
        await _getVerseId(verse.book, verse.chapter, verse.number)
      ],
      limit: 1,
    ))
        .first[_verseText] as String;
    return text.replaceAll('\n', '').replaceAll('--', '\u{2013}');
  }

  Future<File> _createTempDatabaseCopy() async {
    var tempDirectory = await getTemporaryDirectory();
    var copyFile = File('${tempDirectory.path}/scriptures_copy.db');

    if (!await copyFile.exists()) {
      print('Copying scripture database from assets to temp directory...');
      var data = await _assets.load(_databaseAsset);
      var bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      await copyFile.writeAsBytes(bytes, flush: true);
    }

    return copyFile;
  }

  Future<int> _getBookId(Book book) async {
    var db = await data;
    return (await db.query(
      _bookTable,
      columns: [_bookId],
      where: 'lower($_bookTitle)=?',
      whereArgs: <dynamic>[book.title.replaceAll('\u2014', '--').toLowerCase()],
      limit: 1,
    ))
        .first[_bookId] as int;
  }

  Future<int> _getChapterId(Book book, int chapter) async {
    var db = await data;
    return (await db.query(
      _chapterTable,
      columns: [_chapterId],
      where: '$_chapterBook=? AND $_chapterNumber=?',
      whereArgs: <dynamic>[await _getBookId(book), chapter],
      limit: 1,
    ))
        .first[_chapterId] as int;
  }

  Future<int> _getVerseId(Book book, int chapter, int verse) async {
    var db = await data;
    return (await db.query(
      _verseTable,
      columns: [_verseId],
      where: '$_verseChapter=? AND $_verseNumber=?',
      whereArgs: <dynamic>[await _getChapterId(book, chapter), verse],
      limit: 1,
    ))
        .first[_chapterId] as int;
  }
}
