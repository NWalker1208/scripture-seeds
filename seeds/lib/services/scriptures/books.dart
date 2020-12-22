import '../utility.dart';
import 'volumes.dart';

extension BookExtension on Book {
  // Volume
  Volume get volume {
    if (index <= Book.malachi.index) {
      return Volume.oldTestament;
    } else if (index <= Book.revelation.index) {
      return Volume.newTestament;
    } else if (index <= Book.moroni.index) {
      return Volume.bookOfMormon;
    } else if (this == Book.doctrineAndCovenants) {
      return Volume.doctrineAndCovenants;
    } else {
      return Volume.pearlOfGreatPrice;
    }
  }

  // Title
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
    for (var book in Book.values) book: _title(book)
  };

  String get title => _titles[this];

  // URL
  static const _urls = <Book, String>{
    // Old Testament
    Book.genesis: 'gen',
    Book.exodus: 'ex',
    Book.leviticus: 'lev',
    Book.numbers: 'num',
    Book.deuteronomy: 'deut',
    Book.joshua: 'josh',
    Book.judges: 'judg',
    Book.ruth: 'ruth',
    Book.samuel1: '1-sam',
    Book.samuel2: '2-sam',
    Book.kings1: '1-kgs',
    Book.kings2: '2-kgs',
    Book.chronicles1: '1-chr',
    Book.chronicles2: '2-chr',
    Book.ezra: 'ezra',
    Book.nehemiah: 'neh',
    Book.esther: 'esth',
    Book.job: 'job',
    Book.psalms: 'ps',
    Book.proverbs: 'prov',
    Book.ecclesiastes: 'eccl',
    Book.songOfSolomon: 'song',
    Book.isaiah: 'isa',
    Book.jeremiah: 'jer',
    Book.lamentations: 'lam',
    Book.ezekiel: 'ezek',
    Book.daniel: 'dan',
    Book.hosea: 'hosea',
    Book.joel: 'joel',
    Book.amos: 'amos',
    Book.obadiah: 'obad',
    Book.jonah: 'jonah',
    Book.micah: 'micah',
    Book.nahum: 'nahum',
    Book.habakkuk: 'hab',
    Book.zephaniah: 'zeph',
    Book.haggai: 'hag',
    Book.zechariah: 'zech',
    Book.malachi: 'mal',
    // New Testament
    Book.matthew: 'matt',
    Book.mark: 'mark',
    Book.luke: 'luke',
    Book.john: 'john',
    Book.acts: 'acts',
    Book.romans: 'rom',
    Book.corinthians1: '1-cor',
    Book.corinthians2: '2-cor',
    Book.galatians: 'gal',
    Book.ephesians: 'eph',
    Book.philippians: 'philip',
    Book.colossians: 'col',
    Book.thessalonians1: '1-thes',
    Book.thessalonians2: '2-thes',
    Book.timothy1: '1-tim',
    Book.timothy2: '2-tim',
    Book.titus: 'titus',
    Book.philemon: 'philem',
    Book.hebrews: 'heb',
    Book.james: 'james',
    Book.peter1: '1-pet',
    Book.peter2: '2-pet',
    Book.john1: '1-jn',
    Book.john2: '2-jn',
    Book.john3: '3-jn',
    Book.jude: 'jude',
    Book.revelation: 'rev',
    // Book of Mormon
    Book.nephi1: '1-ne',
    Book.nephi2: '2-ne',
    Book.jacob: 'jacob',
    Book.enos: 'enos',
    Book.jarom: 'jarom',
    Book.omni: 'omni',
    Book.wordsOfMormon: 'w-of-m',
    Book.mosiah: 'mosiah',
    Book.alma: 'alma',
    Book.helaman: 'hel',
    Book.nephi3: '3-ne',
    Book.nephi4: '4-ne',
    Book.mormon: 'morm',
    Book.ether: 'ether',
    Book.moroni: 'moro',
    // Other
    Book.doctrineAndCovenants: 'dc',
    Book.moses: 'moses',
    Book.abraham: 'abr',
    Book.josephSmithMatthew: 'js-m',
    Book.josephSmithHistory: 'js-h',
    Book.articlesOfFaith: 'a-of-f',
  };

  String get url => _urls[this];
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
