import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'json.dart';

const String _webStorageURL =
    'https://firebasestorage.googleapis.com/v0/b/scripture-seeds.appspot.com/o/';

/// Loads the TopicIndex from firebase. Do not use when running from web.
class TopicIndexWeb extends TopicIndexJson {
  TopicIndexWeb({String languageCode = 'eng'}) : super(languageCode);

  @override
  Future<String> loadJson() async {
    var cache = await _getCacheFile();
    if (await cache.exists()) return await cache.readAsString();
    if (await refresh()) return await cache.readAsString();
    return null;
  }

  /// Attempt to refresh library cache. Returns true if successful.
  Future<bool> refresh() async {
    final bytes = await _download();
    if (bytes != null) {
      await _saveToCache(bytes);
      return true;
    }
    return false;
  }

  /// Deletes the cache file.
  Future<void> clearCache() async {
    var cache = await _getCacheFile();
    if (await cache.exists()) await cache.delete();
  }

  /// Gets the last modified date of the cache file.
  Future<DateTime> lastRefresh() async {
    var cache = await _getCacheFile();
    if (await cache.exists()) return cache.lastModified();
    return null;
  }

  /// Gets cache file. Do not run from web.
  Future<File> _getCacheFile() async {
    assert(!kIsWeb);
    var tempDirectory = await getTemporaryDirectory();
    return File('${tempDirectory.path}/lib_cache/$filename');
  }

  /// Downloads the library. Returns file as bytes.
  Future<Uint8List> _download() async {
    var url = Uri.parse('$_webStorageURL$filename?alt=media');

    print('Downloading topics from "$url"...');
    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Got response: "${response.body}"');
        return response.bodyBytes;
      } else {
        print('Download failed with code ${response.statusCode}');
      }
    } on Exception catch (e) {
      print('Download failed with exception "$e"');
    }

    return null;
  }

  /// Saves bytes to the cache file.
  Future<void> _saveToCache(Uint8List bytes) async {
    final cache = await _getCacheFile();
    if (!await cache.exists()) await cache.create(recursive: true);
    await cache.writeAsBytes(bytes, flush: true);
  }
}
