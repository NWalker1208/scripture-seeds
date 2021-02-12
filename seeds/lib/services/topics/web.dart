import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'index.dart';
import 'service.dart';

const String _webStorageURL =
    'https://firebasestorage.googleapis.com/v0/b/scripture-seeds.appspot.com/o/';

/// Loads the TopicIndex from firebase.
class WebTopicIndexService extends TopicIndexService<File> {
  WebTopicIndexService({String languageCode = 'eng'}) : super(languageCode);

  @override
  Future<File> open() async {
    if (kIsWeb) return null;
    var tempDirectory = await getTemporaryDirectory();
    return File('${tempDirectory.path}/lib_cache/$filename');
  }

  @override
  Future<TopicIndex> loadIndex() async {
    var cache = await data;
    if (await cache?.exists() ?? false) {
      return parseIndexJson(await cache.readAsString());
    }
    return refresh();
  }

  /// Attempt to download a fresh version of the topic index.
  /// If cache is true, caches the result if successful.
  /// If unable to download, return null.
  Future<TopicIndex> refresh({bool cache = true}) async {
    final json = await _download();
    if (!kIsWeb && cache && json != null) await _saveToCache(json);
    return parseIndexJson(json);
  }

  /// Gets the last modified date of the cache file.
  Future<DateTime> get cacheLastModified async {
    var cache = await data;
    if (await cache?.exists() ?? false) return cache.lastModified();
    return null;
  }

  /// Deletes the cache file.
  Future<void> clearCache() async {
    var cache = await data;
    if (await cache?.exists() ?? false) await cache.delete();
  }

  /// Downloads the library. Returns file as bytes.
  Future<String> _download() async {
    var url = Uri.parse('$_webStorageURL$filename?alt=media');
    print('Downloading topics from "$url"...');
    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Download failed with code ${response.statusCode}');
      }
    } on Exception catch (e) {
      print('Download failed with exception "$e"');
    }
    return null;
  }

  /// Saves json of topic index to the cache file.
  /// Should not be run from web app.
  Future<void> _saveToCache(String json) async {
    assert(!kIsWeb);
    final cache = await data;
    if (!await cache.exists()) await cache.create(recursive: true);
    await cache.writeAsString(json, flush: true);
  }
}
