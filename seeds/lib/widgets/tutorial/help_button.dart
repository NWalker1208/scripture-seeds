import 'package:flutter/material.dart';

import 'help_info.dart';

class HelpButton extends StatelessWidget {
  const HelpButton(this.helpContext, {Key key}) : super(key: key);

  final BuildContext Function() helpContext;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.help),
        tooltip: 'Help',
        onPressed: () => HelpInfo.open(helpContext()),
      );
}
