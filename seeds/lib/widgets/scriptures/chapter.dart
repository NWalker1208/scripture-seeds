import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/scriptures/books.dart';
import '../../services/scriptures/database.dart';
import '../../services/scriptures/reference.dart';
import 'verse.dart';

class ChapterView extends StatefulWidget {
  final ScriptureReference reference;
  final bool scrollToReference;
  final VerseHighlightChangeHandler onHighlightChange;
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
      List<String> chapter, ScriptureReference reference) {
    var groups = <_VerseGroup>[];

    for (var i = 0; i < chapter.length;) {
      var startNumber = i + 1;
      var important = reference.verses.contains(i + 1);
      var verses = <String>[];

      while (
          reference.verses.contains(i + 1) == important && i < chapter.length) {
        verses.add(chapter[i]);
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
  Future<Iterable<String>> _chapter;

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
        .loadChapterOfReference(widget.reference);
    if (widget.scrollToReference) _chapter.then((_) => scrollToReference());
    super.initState();
  }

  @override
  void didUpdateWidget(ChapterView oldWidget) {
    if (oldWidget.reference != widget.reference) {
      // Load chapter text
      _chapter = Provider.of<ScriptureDatabase>(context, listen: false)
          .loadChapterOfReference(widget.reference);
      if (widget.scrollToReference) _chapter.then((_) => scrollToReference());
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _buildAppBar(BuildContext context) {
    final primary = widget.primaryAppBar;
    return SliverAppBar(
      pinned: true,
      primary: primary,
      automaticallyImplyLeading: primary,
      backgroundColor:
          primary ? null : Theme.of(context).scaffoldBackgroundColor,
      foregroundColor:
          primary ? null : Theme.of(context).colorScheme.onBackground,
      iconTheme: primary ? null : Theme.of(context).iconTheme,
      centerTitle: true,
      titleSpacing: 4,
      title: Text('${widget.reference.book.title} ${widget.reference.chapter}'),
      actions: [
        IconButton(
          icon: const Icon(Icons.open_in_new),
          tooltip: 'Open in Gospel Library',
          onPressed: widget.reference.openInGospelLibrary,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstVerse = widget.reference.verses.first;
    final chapterTitle = _buildAppBar(context);

    final referenceDecoration = BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor, width: 3.0),
      borderRadius: BorderRadius.circular(8.0),
    );

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context)
            .textTheme
            .apply(fontFamily: 'Buenard', fontSizeDelta: 5),
      ),
      child: FutureBuilder<Iterable<String>>(
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
                        for (var group in _VerseGroup.createList(
                            snapshot.data.toList(), widget.reference))
                          Container(
                            margin: const EdgeInsets.only(top: 4.0),
                            padding: const EdgeInsets.all(2.0),
                            key: group.startNumber == firstVerse
                                ? _referenceKey
                                : null,
                            foregroundDecoration:
                                group.important ? referenceDecoration : null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (var i = 0; i < group.verses.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: VerseView(
                                      i + group.startNumber,
                                      group.verses[i],
                                      onHighlightChange:
                                          widget.onHighlightChange,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ]),
                    ]),
                  ),
                ),
            ]),
          ],
        ),
      ),
    );
  }
}
