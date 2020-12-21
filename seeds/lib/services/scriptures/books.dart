import '../utility.dart';
import 'volumes.dart';

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

  static String _title(Book book) {
    // Exceptions to usual rules
    if (book == Book.josephSmithHistory) {
      return 'Joseph Smith\u2014History';
    }
    if (book == Book.josephSmithMatthew) {
      return 'Joseph Smith\u2014Matthew';
    }

    // Other books
    var str = enumToString(book);
    if (str[str.length - 1].isNumeric) {
      str = str[str.length - 1] +
          str[0].toUpperCase() +
          str.substring(1, str.length - 1);
    }
    return str.toTitle();
  }
  static final _titles = <Book, String>{
    for (var book in Book.values)
      book: _title(book)
  };

  String get title => _titles[this];
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
  songOfSolomon,
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
