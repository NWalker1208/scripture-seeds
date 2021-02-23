import 'package:flutter/material.dart';

import '../dialogs/help.dart';
import 'step.dart';

/// A widget will provide a tutorial dialog with text information.
class TutorialHelp extends StatelessWidget {
  const TutorialHelp(
    this.tag, {
    this.index = 0,
    this.title = 'Help',
    @required this.helpText,
    this.child,
    Key key,
  }) : super(key: key);

  final String tag;
  final int index;
  final String title;
  final String helpText;
  final Widget child;

  Future<void> showHelp(BuildContext context) => showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) => HelpDialog(
          helpText,
          title: title,
        ),
      );

  @override
  Widget build(BuildContext context) => TutorialStep(
        tag,
        index: index,
        onStart: showHelp,
        child: child,
      );
}
