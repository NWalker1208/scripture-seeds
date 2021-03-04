import 'package:flutter/material.dart';

class HelpDialog extends StatelessWidget {
  final String text;
  final String title;

  HelpDialog(
    this.text, {
    String title,
    Key key,
  })  : title = title ?? 'Help',
        super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      );
}
