import 'package:flutter/foundation.dart';

import '../cached.dart';
import 'books.dart';
import 'database.dart';
import 'reference.dart';
import 'verse.dart';

class ScriptureProvider extends ValueNotifier<
    CachedDatabase<ScriptureDatabase, ScriptureVerse, String>> {
  ScriptureProvider(ScriptureDatabase database)
      : super(CachedDatabase(database));

  /// Loads the text for a verse.
  Future<String> loadVerse(Book book, int chapter, int verse) =>
      value.load(ScriptureVerse(book, chapter, verse));

  /// Loads the text for an entire chapter.
  Future<Iterable<String>> loadChapter(Book book, int chapter) async {
    var verseCount = await value.internal.getVerseCount(book, chapter);

    return [
      for (var verse = 1; verse <= verseCount; verse++)
        await loadVerse(book, chapter, verse),
    ];
  }

  /// Loads the text for the chapter of the given reference.
  Future<Iterable<String>> loadChapterOfReference(ScriptureReference ref) =>
      loadChapter(ref.book, ref.chapter);

  @override
  void dispose() {
    value.close();
    super.dispose();
  }
}
