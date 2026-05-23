import 'package:flutter/foundation.dart';

import 'books.dart';
import 'reference.dart';

@immutable
class ScriptureVerse extends ScriptureReference {
  ScriptureVerse(Book book, int chapter, int verse)
      : super(book, chapter, <int>{verse});

  int get number => verses.single;
}
