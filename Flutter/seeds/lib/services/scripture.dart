import 'library.dart';

class Scripture {
  String book;
  int chapter;
  int verse;

  String get text => Library.scriptures[book][chapter][verse];

  Scripture(this.book, this.chapter, this.verse) {
    if (!Library.scriptures.containsKey(book))
      throw Exception('The book $book is not in the library.');

    if (!Library.scriptures[book].containsKey(chapter))
      throw Exception('Chapter $chapter of $book is not in the library.');

    if (!Library.scriptures[book][chapter].containsKey(verse))
      throw Exception('$book $chapter:$verse is not in the library.');
  }

  @override
  String toString() {
    return '$book $chapter:$verse';
  }
}
