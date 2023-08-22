import 'dart:ui';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../extensions/iterable.dart';
import '../../extensions/string.dart';
import 'books.dart';
import 'volumes.dart';

const String _gospelLibraryUrl =
    'https://www.churchofjesuschrist.org/study/scriptures/';

@immutable
class ScriptureReference implements Comparable<ScriptureReference> {
  ScriptureReference(
    this.book,
    this.chapter,
    Iterable<int> verses,
  )   : volume = book.volume,
        _verses = verses.toBuiltSet();

  final Volume volume;
  final Book book;
  final int chapter;
  final BuiltSet<int> _verses;
  Iterable<int> get verses => _verses;

  String get url => '$_gospelLibraryUrl${volume.url}/${book.url}/'
      '$chapter.${versesToString()}#p${verses.first}';

  factory ScriptureReference.parse(String string) {
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

    return ScriptureReference(
      parseBook(bookStr),
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

  Future<void> openInGospelLibrary() async {
    var gospelLibraryUrl = Uri.tryParse(url);
    if (gospelLibraryUrl != null) {
      print('Opening URL: $gospelLibraryUrl');
      await launchUrl(gospelLibraryUrl, mode: LaunchMode.externalApplication);
    } else {
      print('URL was invalid: $url');
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is ScriptureReference) {
      return other.book == book &&
          other.chapter == chapter &&
          other._verses == _verses;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(book, chapter, verses.hashCode);

  @override
  int compareTo(ScriptureReference other) {
    var c = book.index.compareTo(other.book.index);
    if (c != 0) return c;
    c = chapter.compareTo(other.chapter);
    if (c != 0) return c;

    final verseComps = verses.zip(other.verses, (a, b) => a.compareTo(b));
    return verseComps.firstWhere(
      (c) => c != 0,
      orElse: () => verses.length.compareTo(other.verses.length),
    );
  }

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
