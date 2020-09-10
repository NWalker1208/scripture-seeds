import 'dart:core';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LibraryWebCache {
  static const String _storageURL = 'https://firebasestorage.googleapis.com/v0/b/scripture-seeds.appspot.com/o/';
  static const String _token = '3b4716be-b7aa-4851-991c-7958c9e0df56';

  static Future<File> getLibraryFile({String lang = 'en'}) =>
      DefaultCacheManager().getSingleFile(_getFileURL('library_$lang.xml'));

  static Future<void> resetCachedLibrary({String lang = 'en'}) =>
      DefaultCacheManager().removeFile(_getFileURL('library_$lang.xml'));

  static String _getFileURL(String filename) => '$_storageURL$filename?alt=media&token=$_token';
}
