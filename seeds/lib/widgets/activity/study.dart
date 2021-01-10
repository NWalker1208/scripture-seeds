import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/activity.dart';
import '../../services/topics/reference.dart';
import '../scriptures/chapter.dart';

class StudyActivity extends StatefulWidget {
  const StudyActivity(this.reference, {Key key}) : super(key: key);

  final Reference reference;

  @override
  _StudyActivityState createState() => _StudyActivityState();
}

class _VerseQuote {
  final String quote;
  bool get hasHighlight => (quote?.length ?? 0) > 0;

  _VerseQuote(this.quote);
}

class _StudyActivityState extends State<StudyActivity> {
  Map<int, _VerseQuote> _verses;

  String getSharableQuote() => widget.reference.verses
      .map((verse) => _verses[verse]?.quote)
      .where((str) => str != null)
      .join(' ')
      .replaceAll('... ...', '...');

  bool checkCompleted() =>
      widget.reference.verses.any((v) => _verses[v]?.hasHighlight ?? false);

  void onHighlightChange(int verse, String quote) {
    _verses[verse] = _VerseQuote(quote);
    updateQuote();
  }

  void updateQuote() {
    var activity = Provider.of<ActivityProvider>(context, listen: false);
    activity[0] = checkCompleted();
    activity.quote = getSharableQuote();
  }

  @override
  void initState() {
    _verses = <int, _VerseQuote>{};
    super.initState();
  }

  @override
  void didUpdateWidget(StudyActivity oldWidget) {
    if (oldWidget.reference != widget.reference) {
      _verses = <int, _VerseQuote>{};
      updateQuote();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => ChapterView(
        widget.reference,
        onHighlightChange: onHighlightChange,
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 80.0),
      );
}
