import 'dart:async';

import 'package:flutter/foundation.dart';

import 'books.dart';

abstract class ScriptureDatabase {
  final _cache = <Book, Map<int, Map<int, Future<String>>>>{};

  Future<int> getChapterCount(Book book);

  Future<int> getVerseCount(Book book, int chapter);

  @protected
  Future<String> loadVerseText(Book book, int chapter, int verse);

  Future<String> getVerseText(Book book, int chapter, int verse) {
    if (!_cache.containsKey(book)) {
      _cache[book] = <int, Map<int, Future<String>>>{};
    }
    if (!_cache[book].containsKey(chapter)) {
      _cache[book][chapter] = <int, Future<String>>{};
    }
    if (!_cache[book][chapter].containsKey(verse)) {
      _cache[book][chapter][verse] = loadVerseText(book, chapter, verse);
    }

    return _cache[book][chapter][verse];
  }

  Future<List<String>> getChapterText(Book book, int chapter) async {
    var stopwatch = Stopwatch()..start();

    var verseCount = await getVerseCount(book, chapter);
    var verses = List.generate(
      verseCount,
      (index) => getVerseText(book, chapter, index + 1),
    );

    return Future.wait(verses).then((verses) {
      print('Database loaded ${verses.length} verses from '
          '${book.title} $chapter in ${stopwatch.elapsed}');
      return verses;
    });
  }
}
