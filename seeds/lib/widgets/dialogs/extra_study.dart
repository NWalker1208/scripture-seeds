import 'package:flutter/material.dart';

class ExtraStudyDialog extends StatelessWidget {
  const ExtraStudyDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Daily Activity'),
        content: const Text('You can\'t water this plant again until tomorrow. '
            'Would you like to do an activity anyways?'),
        actions: <Widget>[
          TextButton(
            child: const Text('CONTINUE'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      );
}
