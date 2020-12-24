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
    this.padding = const EdgeInsets.all(8.0),
    Key key,
  }) : super(key: key);

  @override
  _ChapterViewState createState() => _ChapterViewState();
}

class _ChapterViewState extends State<ChapterView> {
  GlobalKey _referenceKey;
  Future<List<String>> _chapter;

  void scrollToReference() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => Scrollable.ensureVisible(
              _referenceKey.currentContext,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
            ));
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
            var verseNumbers = widget.reference.verses;
            return ListView(
              padding: widget.padding,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Chapter Heading
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${widget.reference.book.title} '
                        '${widget.reference.chapter}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(fontFamily: 'Buenard'),
                      ),
                    ),
                    // Verse Text
                    for (var v = 0; v < verses.length; v++)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: HighlightTextSpan(
                          verses[v],
                          leadingText: '${v + 1}. ',
                          style: DefaultTextStyle.of(context).style.copyWith(
                                fontFamily: 'Buenard',
                                fontSize: 20,
                                height: 1.5,
                              ),
                          key: (v + 1) == verseNumbers.first
                              ? _referenceKey
                              : null,
                          onHighlightChange: verseNumbers.isEmpty ||
                                  verseNumbers.contains(v + 1)
                              ? (highlight, quote) => widget.onHighlightChange
                                  ?.call(v + 1, highlight, quote)
                              : null,
                        ),
                      )
                  ],
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
