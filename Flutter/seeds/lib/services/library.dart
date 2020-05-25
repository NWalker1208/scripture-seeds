import 'dart:collection';
import 'package:seeds/services/scripture.dart';

class Library {

  static final Map<String, Map<int, Map<int, String>>> scriptures = {
    'Matthew': {
      17: {
        20: 'And Jesus said unto them, Because of your unbelief: for verily I say unto you, If ye have faith as a grain of mustard seed, ye shall say unto this mountain, Remove hence to yonder place; and it shall remove; and nothing shall be impossible unto you.'
      }
    }
  };

  static final SplayTreeMap<String, List<List<Scripture>>> topics = SplayTreeMap.from({
    'diligence': [
      [Scripture('Matthew',17,20)]
    ],
    'faith': [
      [Scripture('Matthew',17,20)]
    ],
    'integrity': [
      [Scripture('Matthew',17,20)]
    ],
  });

}
