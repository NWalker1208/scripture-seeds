import 'package:flutter/material.dart';

class ExtraStudyDialog extends StatelessWidget {
  const ExtraStudyDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Daily Activity'),
      content: const Text('You can\'t water this plant again until tomorrow. Would you like to do an activity anyways?'),

      actions: <Widget>[
        FlatButton(
            child: const Text('CONTINUE'),
            onPressed: () => Navigator.of(context).pop(true)
        ),

        FlatButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(false)
        ),
      ],
    );
  }
}
