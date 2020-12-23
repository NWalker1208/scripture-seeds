import 'package:flutter/material.dart';

import '../activity/study.dart';
import 'span.dart';

class HighlightStudyBlock extends StatefulWidget {
  final String leadingText;
  final String text;
  final int id;

  HighlightStudyBlock(
    this.text, {
    this.leadingText,
    @required this.id,
    Key key,
  }) : super(key: key) {
    assert(id != null);
  }

  @override
  _HighlightStudyBlockState createState() => _HighlightStudyBlockState();
}

class _HighlightStudyBlockState extends State<HighlightStudyBlock> {
  GlobalKey<HighlightTextSpanState> _highlightKey;

  void updateHighlight(List<bool> highlightedWords) {
    StudyActivity.of(context).updateHighlight(
      widget.id,
      highlightedWords,
      _highlightKey.currentState,
    );
  }

  @override
  void initState() {
    _highlightKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => HighlightTextSpan(
        widget.text,
        leadingText: widget.leadingText,
        style: DefaultTextStyle.of(context)
            .style
            .copyWith(fontFamily: 'Buenard', fontSize: 20, height: 1.5),
        onHighlightChange: updateHighlight,
        key: _highlightKey,
      );
}
