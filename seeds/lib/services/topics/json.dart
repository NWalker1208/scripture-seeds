import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'index.dart';

abstract class TopicIndexJson {
  final String language;
  String get _jsonFileName => 'topics_$language.json';

  TopicIndexJson(this.language);

  Future<TopicIndex> loadIndex() async {
    var map = jsonDecode(await _loadJson()) as Map<String, dynamic>;
    if (map == null) throw Exception('Parsing of topic index JSON failed.');
    return TopicIndex.fromJson(map);
  }

  Future<String> _loadJson();
}

class TopicIndexAssets extends TopicIndexJson {
  final AssetBundle assets;

  TopicIndexAssets({
    String languageCode = 'eng',
    @required this.assets,
  }) : super(languageCode);

  @override
  Future<String> _loadJson() => assets.loadString('assets/$_jsonFileName');
}

class TopicIndexWeb extends TopicIndexJson {
  static const String _webStorageURL =
      'https://firebasestorage.googleapis.com/v0/b/scripture-seeds.appspot.com/o/';

  TopicIndexWeb({String languageCode = 'eng'}) : super(languageCode);

  @override
  // TODO: Download json file from web
  Future<String> _loadJson() async => '{}';

  Future<void> clearCache() async {}
}
