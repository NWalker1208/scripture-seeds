import 'dart:async';

import '../../extensions/iterable.dart';
import '../database.dart';
import 'books.dart';
import 'verse.dart';

/// Database for obtaining scriptural text.
/// D - Internal database instance.
abstract class ScriptureDatabase<D>
    extends CustomDatabase<D, ScriptureVerse, String> {
  /// Avoid calling of possible
  @override
  Future<Iterable<ScriptureVerse>> loadKeys() async => [
        for (var book in Book.values)
          for (var chapter in range(await getChapterCount(book)))
            for (var verse in range(await getVerseCount(book, chapter + 1)))
              ScriptureVerse(book, chapter + 1, verse + 1),
      ];

  /// Returns the number of chapters in a book.
  Future<int> getChapterCount(Book book);

  /// Returns the number of verses in a chapter.
  Future<int> getVerseCount(Book book, int chapter);
}
