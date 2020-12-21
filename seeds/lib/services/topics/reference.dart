import '../../services/utility.dart';

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

// Volume and Book enums
enum Volume {
  oldTestament,
  newTestament,
  bookOfMormon,
  doctrineAndCovenants,
  pearlOfGreatPrice
}

extension BookExtension on Book {
  Volume get volume {
    if (index <= Book.malachi.index) {
      return Volume.oldTestament;
    } else if (index <= Book.revelation.index) {
      return Volume.newTestament;
    } else if (index <= Book.nephi1.index) {
      return Volume.bookOfMormon;
    } else if (this == Book.doctrineAndCovenants) {
      return Volume.doctrineAndCovenants;
    } else {
      return Volume.pearlOfGreatPrice;
    }
  }
}

enum Book {
  genesis,
  exodus,
  leviticus,
  numbers,
  deuteronomy,
  joshua,
  judges,
  ruth,
  samuel1,
  samuel2,
  kings1,
  kings2,
  chronicles1,
  chronicles2,
  ezra,
  nehemiah,
  esther,
  job,
  psalms,
  proverbs,
  ecclesiastes,
  theSongOfSolomon,
  isaiah,
  jeremiah,
  lamentations,
  ezekiel,
  daniel,
  hosea,
  joel,
  amos,
  obadiah,
  jonah,
  micah,
  nahum,
  habakkuk,
  zephaniah,
  haggai,
  zechariah,
  malachi,

  matthew,
  mark,
  luke,
  john,
  acts,
  romans,
  corinthians1,
  corinthians2,
  galatians,
  ephesians,
  philippians,
  colossians,
  thessalonians1,
  thessalonians2,
  timothy1,
  timothy2,
  titus,
  philemon,
  hebrews,
  james,
  peter1,
  peter2,
  john1,
  john2,
  john3,
  jude,
  revelation,

  nephi1,
  nephi2,
  jacob,
  enos,
  jarom,
  omni,
  wordsOfMormon,
  mosiah,
  alma,
  helaman,
  nephi3,
  nephi4,
  mormon,
  ether,
  moroni,

  doctrineAndCovenants,
  moses,
  abraham,
  josephSmithMatthew,
  josephSmithHistory,
  articlesOfFaith
}
