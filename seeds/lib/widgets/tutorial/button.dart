import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/tutorial/provider.dart';

class TutorialButton extends StatelessWidget {
  const TutorialButton({this.tag, Key key}) : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.help),
        tooltip: 'Help',
        onPressed: () => Provider.of<TutorialProvider>(context, listen: false)
            .show(ModalRoute.of(context).subtreeContext, tag),
      );
}
