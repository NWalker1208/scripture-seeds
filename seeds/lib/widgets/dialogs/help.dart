import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/settings/help.dart';

class HelpDialog extends StatelessWidget {
  final String text;
  final String title;
  final String page;

  HelpDialog(
    this.text, {
    String title,
    this.page = 'default',
    Key key,
  })  : title = title ?? 'Help',
        super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(text),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Consumer<HelpSettings>(
                  builder: (context, settings, child) => Checkbox(
                    value: settings.getShowHelp(page) ?? false,
                    onChanged: (showHelp) =>
                        settings.setShowHelp(page, showHelp: showHelp),
                  ),
                ),
                Text('Always show')
              ],
            )
          ],
        ),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
}
