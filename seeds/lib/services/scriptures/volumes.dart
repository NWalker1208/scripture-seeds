import '../utility.dart';

extension VolumeExtension on Volume {
  // Title
  static String _title(Volume vol) {
    var str = enumToString(vol);
    if (str[str.length - 1].isNumeric) {
      str = str[str.length - 1] +
          str[0].toUpperCase() +
          str.substring(1, str.length - 1);
    }
    return str.toTitle();
  }

  static final _titles = <Volume, String>{
    for (var vol in Volume.values) vol: _title(vol)
  };

  String get title => _titles[this];

  // URL
  static const _urls = <Volume, String>{
    Volume.oldTestament: 'ot',
    Volume.newTestament: 'nt',
    Volume.bookOfMormon: 'bofm',
    Volume.doctrineAndCovenants: 'dc-testament',
    Volume.pearlOfGreatPrice: 'pgp',
  };

  String get url => _urls[this];
}

enum Volume {
  oldTestament,
  newTestament,
  bookOfMormon,
  doctrineAndCovenants,
  pearlOfGreatPrice
}
