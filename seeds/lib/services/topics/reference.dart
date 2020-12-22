import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../services/utility.dart';
import '../scriptures/books.dart';
import '../scriptures/volumes.dart';

@immutable
class Reference {
  static const String gospelLibraryUrl =
      'https://www.churchofjesuschrist.org/study/scriptures/';

  final Volume volume;
  final Book book;
  final int chapter;
  final Set<int> verses;

  String get url => '$gospelLibraryUrl${volume.url}/${book.url}/'
      '$chapter.${versesToString()}#p${verses.first}';

  Reference(
    this.book,
    this.chapter,
    Iterable<int> verses,
  )   : volume = book.volume,
        verses = verses.toSet();

  factory Reference.parse(String string) {
    var spaceIndex = string.lastIndexOf(' ');
    var colonIndex = string.indexOf(':');

    var bookStr = string.substring(0, spaceIndex);
    var chapterStr = string.substring(spaceIndex + 1, colonIndex);
    var versesStr = string.substring(colonIndex + 1);

    if (bookStr.isEmpty || chapterStr.isEmpty || versesStr.isEmpty) {
      throw FormatException(
        'String reference is not formatted correctly.',
        string,
      );
    }

    // Move book number to end if necessary
    if (bookStr[0].isNumeric) {
      bookStr = bookStr.substring(2) + bookStr[0];
    }

    // Remove whitespace and dashes
    bookStr = bookStr.replaceAll(RegExp(r'[ -]'), '');

    return Reference(
      bookStr.toEnum(Book.values),
      int.parse(chapterStr),
      stringToVerseSet(versesStr),
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

  @override
  bool operator ==(Object other) {
    if (other is Reference) {
      return other.book == book &&
          other.chapter == chapter &&
          other.verses.containsAll(verses) &&
          verses.containsAll(other.verses);
    }
    return false;
  }

  @override
  int get hashCode =>
      book.hashCode +
      chapter.hashCode * 100 +
      verses.reduce((value, element) => value + element.hashCode) * 500;

  @override
  String toString() => '${book.title} $chapter:${versesToString()}';

  String versesToString() {
    var str = '';

    var range = false;
    int lastVerse;
    for (var verse in verses) {
      if (verse - 1 != lastVerse) {
        if (range) {
          str += '-$lastVerse,';
          range = false;
        } else if (lastVerse != null) {
          str += ',';
        }

        str += '$verse';
      } else {
        range = true;
      }

      lastVerse = verse;
    }

    if (range) str += '-$lastVerse';

    return str;
  }
}
