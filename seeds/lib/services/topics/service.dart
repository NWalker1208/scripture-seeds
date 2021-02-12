import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../service.dart';
import 'index.dart';

abstract class TopicIndexService<D> extends CustomService<D> {
  TopicIndexService(this.language);

  /// Language of the topic index.
  final String language;

  /// Filename of the index file.
  @protected
  String get filename => 'topics_$language.json';

  /// Loads the TopicIndex. Returns null upon failure.
  Future<TopicIndex> loadIndex();
}

/// Parse a JSON string into a TopicIndex.
/// If the JSON is formatted incorrectly, or if the TopicIndex cannot
/// be created from the decoded object, this will return null.
TopicIndex parseIndexJson(String json) {
  if (json == null) {
    print('Failed to obtain JSON for TopicIndex, received null.');
    return null;
  }
  try {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return TopicIndex.fromJson(map);
  } on FormatException catch (e) {
    print('Failed for decode JSON for TopicIndex: $e');
  } on CheckedFromJsonException catch (e) {
    print('Failed to create TopicIndex from JSON: $e');
  }
  return null;
}
