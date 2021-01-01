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
  final bool primaryAppBar;

  ChapterView(
    this.reference, {
    this.scrollToReference = true,
    this.onHighlightChange,
    this.padding = const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
    this.primaryAppBar = false,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
  Widget build(BuildContext context) {
    final firstVerse = widget.reference.verses.first;
    final chapterTitle =
        _ChapterAppBar(widget.reference, primary: widget.primaryAppBar);

    return FutureBuilder(
      future: _chapter,
      builder: (context, snapshot) => Stack(
        alignment: Alignment.center,
        children: [
          // Loading indicator
          if (!snapshot.hasData && !snapshot.hasError)
            CircularProgressIndicator(),
          // Error message
          if (snapshot.hasError)
            Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.error),
              Text(
                'An error occurred.\n'
                'Please exit and try again.',
                textAlign: TextAlign.center,
              ),
            ]),
          // Chapter text
          CustomScrollView(slivers: [
            chapterTitle,
            if (snapshot.hasData)
              SliverPadding(
                padding: widget.padding,
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Column(children: [
                      // Verse Text
                      for (var group in _VerseGroup.createList(
                          snapshot.data as List<String>, widget.reference))
                        _VerseGroupView(
                          group,
                          onHighlightChange: widget.onHighlightChange,
                          key: group.startNumber == firstVerse
                              ? _referenceKey
                              : null,
                        )
                    ])
                  ]),
                ),
              ),
          ]),
        ],
      ),
    );
  }
}

class _ChapterAppBar extends StatelessWidget {
  final Reference reference;
  final bool primary;

  const _ChapterAppBar(
    this.reference, {
    this.primary = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverAppBar(
        pinned: true,
        primary: primary,
        automaticallyImplyLeading: primary,
        brightness: Brightness.dark,
        backgroundColor: primary
            ? Theme.of(context).primaryColor
            : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
        centerTitle: true,
        titleSpacing: 4,
        titleTextStyle: Theme.of(context).textTheme.headline5.copyWith(
            fontFamily: 'Buenard', color: primary ? Colors.white : Colors.black),
        title: Text('${reference.book.title} ${reference.chapter}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            color: primary
                ? Colors.white
                : Theme.of(context).textTheme.headline5.color,
            tooltip: 'Open in Gospel Library',
            onPressed: reference.openInGospelLibrary,
          ),
        ],
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
