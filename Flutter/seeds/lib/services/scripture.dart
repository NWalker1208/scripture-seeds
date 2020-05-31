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

  static List<Scripture> block(String book, int chapter, List<int> verses)
  {
    return verses.map((verse) => Scripture(book, chapter, verse)).toList();
  }

  String reference({showVerse = true}) {
    if (showVerse)
      return '$book $chapter:$verse';
    else
      return '$book $chapter';
  }

  @override
  String toString() {
    return text;
  }

  String quoteHighlight(List<bool> wordsHighlighted) {
    List<String> quote = List<String>();
    List<String> words = text.split(' ');

    bool wordsSkipped = false;
    for (int i = 0; i < wordsHighlighted.length && i < words.length; i++) {
      if (wordsHighlighted[i]) {
        quote.add(words[i]);
        wordsSkipped = false;
      } else if (!wordsSkipped) {
        quote.add('...');
        wordsSkipped = true;
      }
    }

    return quote.join(' ');
  }

  static String quoteBlockHighlight(List<Scripture> verses, List<List<bool>> wordsHighlighted) {
    List<String> quote = List<String>();

    for (int i = 0; i < verses.length; i++)
      quote.add(verses[i].quoteHighlight(wordsHighlighted[i]));

    return quote.join(' ');
  }
}
