import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/settings/help.dart';

class HelpDialog extends StatelessWidget {
  final String text;
  final String title;
  final String page;

  HelpDialog(this.text, {String title, this.page = 'default', Key key}) :
    this.title = title ?? 'Help',
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                builder: (context, settings, child) =>
                  Checkbox(
                    value: settings.getShowHelp(page) ?? false,
                    onChanged: (bool showHelp) => settings.setShowHelp(page, showHelp),
                  )
              ),

              Text('Always show')
            ],
          )
        ],
      ),
      actions: [
        FlatButton(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop()
        ),
      ],
    );
  }
}
