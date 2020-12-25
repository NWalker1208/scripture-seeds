import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/scriptures/books.dart';
import '../../services/scriptures/database.dart';
import '../../services/topics/reference.dart';
import 'span.dart';

class ChapterView extends StatefulWidget {
  final Reference reference;
  final bool scrollToReference;
  final void Function(int verse, List<bool> highlight, String quote)
      onHighlightChange;
  final EdgeInsets padding;

  ChapterView(
    this.reference, {
    this.scrollToReference = true,
    this.onHighlightChange,
    this.padding = const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
    Key key,
  }) : super(key: key);

  @override
  _ChapterViewState createState() => _ChapterViewState();
}

class _VerseGroup {
  final bool important;
  final int startNumber;
  final List<String> verses;

  _VerseGroup({this.important, this.startNumber, this.verses});

  static List<_VerseGroup> createList(
    List<String> allVerses,
    Reference reference,
  ) {
    var groups = <_VerseGroup>[];

    for (var i = 0; i < allVerses.length;) {
      var startNumber = i + 1;
      var important = reference.verses.contains(i + 1);
      var verses = <String>[];

      while (reference.verses.contains(i + 1) == important &&
          i < allVerses.length) {
        verses.add(allVerses[i]);
        i++;
      }

      groups.add(_VerseGroup(
        important: important,
        verses: verses,
        startNumber: startNumber,
      ));
    }

    return groups;
  }
}

class _ChapterViewState extends State<ChapterView> {
  GlobalKey _referenceKey;
  Future<List<String>> _chapter;

  void scrollToReference() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
          if (_referenceKey.currentContext != null) {
            Scrollable.ensureVisible(
              _referenceKey.currentContext,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
            );
          } else {
            print('Unable to scroll to reference.');
          }
        });
  }

  @override
  void initState() {
    _referenceKey = GlobalKey();
    // Load chapter text
    _chapter = Provider.of<ScriptureDatabase>(context, listen: false)
        .getChapterText(widget.reference.book, widget.reference.chapter);
    if (widget.scrollToReference) _chapter.then((_) => scrollToReference());
    super.initState();
  }

  @override
  void didUpdateWidget(ChapterView oldWidget) {
    if (oldWidget.reference != widget.reference) {
      // Load chapter text
      _chapter = Provider.of<ScriptureDatabase>(context, listen: false)
          .getChapterText(widget.reference.book, widget.reference.chapter);
      if (widget.scrollToReference) _chapter.then((_) => scrollToReference());
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _chapter,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var verses = snapshot.data as List<String>;
            var firstOfReference = widget.reference.verses.first;
            var groups = _VerseGroup.createList(verses, widget.reference);

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  primary: false,
                  automaticallyImplyLeading: false,
                  brightness: Theme.of(context).brightness,
                  backgroundColor: Theme.of(context)
                      .scaffoldBackgroundColor.withOpacity(0.95),
                  centerTitle: true,
                  title:  Text(
                        '${widget.reference.book.title} '
                        '${widget.reference.chapter}',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontFamily: 'Buenard')),
                ),
                SliverPadding(
                  padding: widget.padding,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Column(
                        children: [
                          // Verse Text
                          for (var group in groups)
                            _VerseGroupView(
                              group,
                              onHighlightChange: widget.onHighlightChange,
                              key: group.startNumber == firstOfReference
                                  ? _referenceKey
                                  : null,
                            )
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.error),
                Text(
                  'An error occurred.\n'
                  'Please exit and try again.',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
}

class _VerseGroupView extends StatelessWidget {
  final _VerseGroup group;
  final void Function(int verse, List<bool> highlight, String quote)
      onHighlightChange;

  _VerseGroupView(
    this.group, {
    this.onHighlightChange,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final referenceDecoration = BoxDecoration(
      border: Border.all(
        color: Theme.of(context).accentColor,
        width: 4.0,
      ),
      borderRadius: BorderRadius.circular(8.0),
    );

    final verseStyle = DefaultTextStyle.of(context).style.copyWith(
          fontFamily: 'Buenard',
          fontSize: 20,
          //height: 1.5,
        );

    return Container(
      foregroundDecoration: group.important ? referenceDecoration : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < group.verses.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HighlightTextSpan(
                group.verses[i],
                leadingText: '${i + group.startNumber}. ',
                style: verseStyle,
                onHighlightChange: (highlight, quote) => onHighlightChange
                    ?.call(i + group.startNumber, highlight, quote),
              ),
            ),
        ],
      ),
    );
  }
}
