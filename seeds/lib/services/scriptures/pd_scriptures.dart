import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'books.dart';
import 'database.dart';

class PublicDomainScriptures extends ScriptureDatabase {
  static const String _databaseAsset =
      'assets/lds-scriptures/sqlite/lds-scriptures-sqlite.db';

  // Database Schema
  static const String _bookTable = 'books';
  static const String _bookId = 'id';
  //static const String _bookVolume = 'volume_id';
  static const String _bookTitle = 'book_title';

  static const String _chapterTable = 'chapters';
  static const String _chapterId = 'id';
  static const String _chapterBook = 'book_id';
  static const String _chapterNumber = 'chapter_number';

  static const String _verseTable = 'verses';
  static const String _verseId = 'id';
  static const String _verseChapter = 'chapter_id';
  static const String _verseNumber = 'verse_number';
  static const String _verseText = 'scripture_text';

  /*static const String _volumeTable = 'volumes';
  static const String _volumeId = 'id';
  static const String _volumeTitle = 'volume_title';*/

  // Database helper
  final AssetBundle _assets;

  Future<Database> _db;

  PublicDomainScriptures({AssetBundle assets})
      : _assets = assets ?? rootBundle {
    print('Loading public domain scriptures database...');
    _db = _createTempDatabaseCopy().then((file) => openDatabase(file.path));
    _db.then((_) => print('Public domain scripture database loaded!'));
  }

  Future<int> _getBookId(Book book) async {
    var db = await _db;
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
    var db = await _db;
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
    var db = await _db;
    return (await db.query(
      _verseTable,
      columns: [_verseId],
      where: '$_verseChapter=? AND $_verseNumber=?',
      whereArgs: <dynamic>[await _getChapterId(book, chapter), verse],
      limit: 1,
    ))
        .first[_chapterId] as int;
  }

  @override
  Future<int> getChapterCount(Book book) async {
    var db = await _db;
    var chapters = await db.query(
      _chapterTable,
      where: '$_chapterBook=?',
      whereArgs: <dynamic>[await _getBookId(book)],
    );

    return chapters.length;
  }

  @override
  Future<int> getVerseCount(Book book, int chapter) async {
    var db = await _db;
    var verses = await db.query(
      _verseTable,
      where: '$_verseChapter=?',
      whereArgs: <dynamic>[await _getChapterId(book, chapter)],
    );

    return verses.length;
  }

  @override
  Future<String> loadVerseText(Book book, int chapter, int verse) async {
    var db = await _db;
    final text = (await db.query(
      _verseTable,
      columns: [_verseText],
      where: '$_verseId=?',
      whereArgs: <dynamic>[await _getVerseId(book, chapter, verse)],
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
}
