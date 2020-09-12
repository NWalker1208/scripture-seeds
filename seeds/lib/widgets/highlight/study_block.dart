import 'package:flutter/material.dart';
import 'package:seeds/widgets/activities/study.dart';
import 'package:seeds/widgets/highlight/span.dart';

class HighlightStudyBlock extends StatefulWidget {
  final String leadingText;
  final String text;
  final int id;

  HighlightStudyBlock(this.text, {this.leadingText, @required this.id, Key key}) : super(key: key) {
    assert(id != null);
  }

  @override
  _HighlightStudyBlockState createState() => _HighlightStudyBlockState();
}

class _HighlightStudyBlockState extends State<HighlightStudyBlock> {
  List<WordState> highlight;

  void updateHighlight(Map<int,bool> changes) {
    setState(() {
      changes.forEach((index, value) => highlight[index].highlighted = value);
      StudyActivity.of(context).updateHighlight(widget.id, highlight);
    });
  }

  @override
  void initState() {
    super.initState();

    highlight = StudyActivity.of(context).highlights[widget.id];

    if (highlight == null) {
      highlight = buildWordList(widget.text);
      StudyActivity.of(context).highlights[widget.id] = highlight;
    }
  }

  @override
  void didUpdateWidget(HighlightStudyBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text)
      highlight = buildWordList(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return HighlightTextSpan(
      highlight,
      leadingText: widget.leadingText,
      style: DefaultTextStyle.of(context).style.copyWith(
        fontFamily: 'Buenard',
        fontSize: 20,
        height: 1.5
      ),
      onChangeHighlight: updateHighlight,
    );
  }
}
