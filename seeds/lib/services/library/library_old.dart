import 'dart:collection';
import 'package:seeds/services/library/scripture.dart';

class Library {

  static final Map<String, Map<int, Map<int, String>>> scriptures = {
    /// Old Testament
    'Job': {
      2: {
        3: 'And the Lord said unto Satan, Hast thou considered my servant Job, ' +
           'that there is none like him in the earth, a perfect and an upright ' +
           'man, one that feareth God, and escheweth evil? and still he holdeth ' +
           'fast his integrity, although thou movedst me against him, to destroy ' +
           'him without cause.',
      },
    },

    /// New Testament
    'Matthew': {
      17: {
        20: 'And Jesus said unto them, Because of your unbelief: for verily ' +
            'I say unto you, If ye have faith as a grain of mustard seed, ye ' +
            'shall say unto this mountain, Remove hence to yonder place; and ' +
            'it shall remove; and nothing shall be impossible unto you.',
      },
    },

    'James': {
      2: {
        14: 'What doth it profit, my brethren, though a man say he hath faith, ' +
            'and have not works? can faith save him?',
        17: 'Even so faith, if it hath not works, is dead, being alone.',
        18: 'Yea, a man may say, Thou hast faith, and I have works: shew me ' +
            'thy faith without thy works, and I will shew thee my faith by my works.',
        19: 'Thou believest that there is one God; thou doest well: the devils ' +
            'also believe, and tremble.',
        24: 'Ye see then how that by works a man is justified, and not by faith only.',
      },
    },

    /// Book of Mormon
    'Moroni': {
      9: {
        6: 'And now, my beloved son, notwithstanding their hardness, let us ' +
           'labor diligently; for if we should cease to labor, we should be ' +
           'brought under condemnation; for we have a labor to perform whilst ' +
           'in this tabernacle of clay, that we may conquer the enemy of all ' +
           'righteousness, and rest our souls in the kingdom of God.',
      },
    },
  };

  static final SplayTreeMap<String, List<List<Scripture>>> topics = SplayTreeMap.from({
    'diligence': [
      [Scripture('Moroni',9,6)],
    ],
    'faith': [
      [Scripture('Matthew',17,20)],
      Scripture.block('James', 2, [14, 17, 18, 19, 24]),
    ],
    'integrity': [
      [Scripture('Job',2,3)],
    ],
  });

}
