import 'package:seeds/services/library/library_old.dart';

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
      if (wordsHighlighted[i] != null)
        quote.add(verses[i].quoteHighlight(wordsHighlighted[i]));

    return quote.join('\n');
  }

  static String blockReference(List<Scripture> verses) {
    String lastBook;
    int lastChapter;
    int lastVerse;

    String ref = '';

    for(int i = 0; i < verses.length; i++) {
      // Add name of book if first or different
      if (verses[i].book != lastBook) {
        lastBook = verses[i].book;
        lastChapter = null;
        lastVerse = null;

        if (lastVerse != null)
          ref += ', ';
        ref += lastBook + ' ';
      }

      // Add chapter if first or different
      if (verses[i].chapter != lastChapter) {
        lastChapter = verses[i].chapter;
        lastVerse = null;

        if (lastVerse != null)
          ref += ', ';
        ref += lastChapter.toString() + ':';
      }

      // Add verse if first, last, or there is a gap
      if (verses[i].verse - 1 != lastVerse) {
        if (lastVerse != null)
          ref += ',';

        ref += verses[i].verse.toString();
      } else if (i == verses.length - 1 ||
                 verses[i + 1].book != lastBook ||
                 verses[i + 1].chapter != lastChapter ||
                 verses[i + 1].verse - 2 != lastVerse) {

        if (lastVerse != null)
          ref += '-';

        ref += verses[i].verse.toString();
      }

      lastVerse = verses[i].verse;
    }

    return ref;
  }
}
