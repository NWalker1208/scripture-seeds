import 'package:flutter/material.dart';

class InstructionsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Test"),
      content: Text("Content"),
      actions: [
        RaisedButton(
          child: Text("Ok"),
          onPressed: () => Navigator.of(context).pop(false)
        )
      ],
    );
  }
}
