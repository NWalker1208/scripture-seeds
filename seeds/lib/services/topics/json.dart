import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'index.dart';

abstract class TopicIndexJson {
  final String language;
  String get _jsonFileName => 'topics_$language.json';

  TopicIndexJson(this.language);

  Future<TopicIndex> loadIndex() async {
    var json = await _loadJson();
    if (json == null) return null;

    var map = jsonDecode(json) as Map<String, dynamic>;
    if (map == null) throw Exception('Parsing of topic index JSON failed.');
    return TopicIndex.fromJson(map);
  }

  Future<String> _loadJson();
}

class TopicIndexAssets extends TopicIndexJson {
  final AssetBundle _assets;

  TopicIndexAssets({
    String languageCode = 'eng',
    AssetBundle assets,
  })  : _assets = assets ?? rootBundle,
        super(languageCode);

  @override
  Future<String> _loadJson() => _assets.loadString('assets/$_jsonFileName');
}

class TopicIndexWeb extends TopicIndexJson {
  static const String _webStorageURL =
      'https://firebasestorage.googleapis.com/v0/b/scripture-seeds.appspot.com/o/';

  TopicIndexWeb({String languageCode = 'eng'}) : super(languageCode);

  @override
  Future<String> _loadJson() async {
    var cache = await _getCacheFile();
    if (await cache.exists()) return await cache.readAsString();

    // Download topics to cache
    if (await _download(cache)) return await cache.readAsString();

    // Failed to obtain web topics
    return null;
  }

  // Attempt to refresh library from web. Returns true if successful.
  Future<bool> refresh() async => _download(await _getCacheFile());

  // Deletes the cache file
  Future<void> clearCache() async {
    var cache = await _getCacheFile();
    if (await cache.exists()) await cache.delete();
  }

  // Gets the last modified date of the cache file
  Future<DateTime> lastRefresh() async {
    var cache = await _getCacheFile();
    if (await cache.exists()) return cache.lastModified();
    return null;
  }

  // Gets cache file
  Future<File> _getCacheFile() async {
    var tempDirectory = await getTemporaryDirectory();
    return File('${tempDirectory.path}/lib_cache/$_jsonFileName');
  }

  // Downloads the library and saves to the cache. Returns true if successful.
  Future<bool> _download(File cache) async {
    var url = Uri.parse('$_webStorageURL$_jsonFileName?alt=media');

    print('Downloading topics from "$url"...');
    List<int> bytes;
    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        bytes = response.bodyBytes;
      } else {
        print('Download failed with code ${response.statusCode}');
        return false;
      }
    } on Exception catch (e) {
      print('Download failed with exception $e');
      return false;
    }

    // Save download
    if (!await cache.exists()) await cache.create(recursive: true);
    await cache.writeAsBytes(bytes, flush: true);

    return true;
  }
}
