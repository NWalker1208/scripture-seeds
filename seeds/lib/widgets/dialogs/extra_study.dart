import 'package:flutter/material.dart';

class ExtraStudyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Daily Activity'),
      content: Text('You can\'t water this plant again until tomorrow. Would you like to do an activity anyways?'),

      actions: <Widget>[
        FlatButton(
            child: Text('CONTINUE'),
            onPressed: () => Navigator.of(context).pop(true)
        ),

        FlatButton(
            child: Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(false)
        ),
      ],
    );
  }
}
