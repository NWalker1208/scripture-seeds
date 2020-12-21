import 'dart:async';

import '../topics/reference.dart';
import 'library.dart';

abstract class ScriptureDatabase {
  Future<ScriptureLibrary> loadLibrary() async {
    var verses = <Book, List<List<String>>>{};

    for (var book in Book.values) {
      var chapterCount = await getChapterCount(book);
      verses[book] = List<List<String>>.filled(chapterCount, []);

      for (var chapter = 1; chapter <= chapterCount; chapter++) {
        var verseCount = await getVerseCount(book, chapter);
        verses[book][chapter - 1] = List<String>.filled(verseCount, '');

        for (var verse = 1; verse <= verseCount; verse++) {
          verses[book][chapter - 1][verse - 1] = await getText(
            book,
            chapter,
            verse,
          );
        }
      }
    }

    return ScriptureLibrary(verses);
  }

  Future<int> getChapterCount(Book book);
  Future<int> getVerseCount(Book book, int chapter);
  Future<String> getText(Book book, int chapter, int verse);
}
