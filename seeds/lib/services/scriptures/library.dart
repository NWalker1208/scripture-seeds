import '../topics/reference.dart';

class ScriptureLibrary {
  final Map<Book, List<List<String>>> _verses;

  ScriptureLibrary(Map<Book, List<List<String>>> verses) : _verses = verses;

  int chapters(Book book) => _verses[book].length;
  int verses(Book book, int chapter) => _verses[book][chapter].length;

  List<String> operator [](Reference reference) => [
        for (var verse in reference.verses)
          _verses[reference.book][reference.chapter - 1][verse - 1]
      ];

  // Gets the total number of chapters stored
  int get chapterCount => _verses.values
      .map((b) => b.length)
      .reduce((v, e) => v + e);

  // Gets the total number of verses stored
  int get verseCount => _verses.values
      .map((b) => b.map((c) => c.length).reduce((v, e) => v + e))
      .reduce((v, e) => v + e);
}
