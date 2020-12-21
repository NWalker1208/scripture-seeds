import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../topics/reference.dart';
import 'database.dart';

class PublicDomainScriptures extends ScriptureDatabase {
  static const String _databaseAsset =
      'assets/lds-scriptures/sqlite/lds-scriptures-sqlite.db';
  final AssetBundle _assets;

  Future<Database> _db;

  PublicDomainScriptures({AssetBundle assets})
      : _assets = assets ?? rootBundle {
    _db = _createTempDatabaseCopy().then((file) => openDatabase(file.path));
  }

  @override
  Future<int> getChapterCount(Book book) async {
    // TODO: implement getChapterCount
    var db = await _db;
    throw UnimplementedError();
  }

  @override
  Future<String> getText(Book book, int chapter, int verse) async {
    // TODO: implement getText
    var db = await _db;
    throw UnimplementedError();
  }

  @override
  Future<int> getVerseCount(Book book, int chapter) async {
    // TODO: implement getVerseCount
    var db = await _db;
    throw UnimplementedError();
  }

  Future<File> _createTempDatabaseCopy() async {
    var tempDirectory = await getTemporaryDirectory();
    var copyFile = File('${tempDirectory.path}/scriptures_copy.db');

    if (!await copyFile.exists()) {
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
