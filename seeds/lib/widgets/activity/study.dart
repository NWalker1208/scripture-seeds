import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/activity.dart';
import '../../services/topics/reference.dart';
import '../highlight/chapter.dart';

class StudyActivity extends StatefulWidget {
  final Reference reference;

  const StudyActivity(this.reference, {Key key}) : super(key: key);

  @override
  _StudyActivityState createState() => _StudyActivityState();
}

class _StudyActivityState extends State<StudyActivity> {
  Map<int, String> _quotes;
  Map<int, List<bool>> _highlights;

  String getSharableQuote() => widget.reference.verses
      .map((verse) => _quotes[verse])
      .where((str) => str != null)
      .join(' ')
      .replaceAll('... ...', '...');

  bool checkCompleted() {
    for (var verse in widget.reference.verses) {
      for (var word in _highlights[verse] ?? <bool>[]) {
        if (word) return true;
      }
    }

    return false;
  }

  void updateHighlight(int verse, List<bool> highlight, String quote) {
    _quotes[verse] = quote;
    _highlights[verse] = highlight;
    updateQuote();
  }

  void updateQuote() {
    var activity = Provider.of<ActivityProvider>(context, listen: false);
    activity[0] = checkCompleted();
    activity.quote = getSharableQuote();
  }

  @override
  void initState() {
    _quotes = <int, String>{};
    _highlights = <int, List<bool>>{};
    super.initState();
  }

  @override
  void didUpdateWidget(StudyActivity oldWidget) {
    if (oldWidget.reference != widget.reference) {
      _quotes = <int, String>{};
      _highlights = <int, List<bool>>{};
      updateQuote();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => ChapterView(
    widget.reference,
    onHighlightChange: updateHighlight,
    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 80.0),
  );
}
