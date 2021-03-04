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
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('CONTINUE'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
        ],
      );
}
