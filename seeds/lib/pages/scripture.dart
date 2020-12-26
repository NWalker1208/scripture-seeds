import 'package:flutter/material.dart';

import '../services/topics/reference.dart';
import '../widgets/highlight/chapter.dart';

class ScripturePage extends StatelessWidget {
  final Reference reference;

  const ScripturePage(this.reference, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChapterView(reference, primaryAppBar: true),
      );
}
