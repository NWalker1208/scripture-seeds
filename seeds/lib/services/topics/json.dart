import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'index.dart';

abstract class TopicIndexJson {
  TopicIndexJson(this.language);

  /// Language of the topic index.
  final String language;

  /// Filename of the index file.
  @protected
  String get filename => 'topics_$language.json';

  /// Loads the TopicIndex.
  Future<TopicIndex> loadIndex() async {
    var json = await loadJson();
    if (json == null) return null;

    var map = jsonDecode(json) as Map<String, dynamic>;
    if (map == null) throw Exception('Parsing of topic index JSON failed.');
    return TopicIndex.fromJson(map);
  }

  /// Load JSON text from storage.
  @protected
  Future<String> loadJson();
}

class TopicIndexAssets extends TopicIndexJson {
  TopicIndexAssets({
    String languageCode = 'eng',
    AssetBundle assets,
  })  : _assets = assets ?? rootBundle,
        super(languageCode);

  final AssetBundle _assets;

  @override
  Future<String> loadJson() => _assets.loadString('assets/$filename');
}
