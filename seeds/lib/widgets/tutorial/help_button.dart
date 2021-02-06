import 'package:flutter/material.dart';

import 'help_info.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({
    this.filter,
    Key key,
  }) : super(key: key);

  final Object filter;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.help),
        tooltip: 'Help',
        onPressed: () => HelpInfo.open(
          ModalRoute.of(context).subtreeContext,
          filter: filter,
        ),
      );
}
