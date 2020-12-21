import '../../services/utility.dart';
import '../scriptures/books.dart';
import '../scriptures/volumes.dart';

class Reference {
  final Volume volume;
  final Book book;
  final int chapter;
  final Set<int> verses;

  Reference({
    this.book,
    this.chapter,
    Iterable<int> verses,
  })  : volume = book.volume,
        verses = verses.toSet();

  factory Reference.parse(String string) {
    var parts = string.split(RegExp(r'[ :]'));

    if (parts.length < 3) {
      throw FormatException(
        'String reference is not formatted correctly',
        string,
      );
    }

    return Reference(
      book: parts[0].toEnum(Book.values),
      chapter: int.parse(parts[1]),
      verses: stringToVerseSet(parts[2]),
    );
  }

  static Set<int> stringToVerseSet(String str) {
    var verseGroups = str.split(',');
    var verses = <int>{};

    for (var verseGroup in verseGroups) {
      var range = verseGroup.split('-');
      var start = int.parse(range[0]);

      if (range.length > 1) {
        var end = int.parse(range[1]);
        verses.addAll(List<int>.generate(end - start + 1, (i) => i + start));
      } else {
        verses.add(start);
      }
    }

    return verses;
  }
}
