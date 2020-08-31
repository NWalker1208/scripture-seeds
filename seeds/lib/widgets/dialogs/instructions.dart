import 'package:flutter/material.dart';

class InstructionsDialog extends StatelessWidget {
  final String instructions;

  InstructionsDialog(this.instructions, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Test"),
      content: Column(
        children: [
          Text(instructions),
          Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (_) {},
              ),

              Text("Always show instructions")
            ],
          )
        ],
      ),
      actions: [
        RaisedButton(
          child: Text("Ok"),
          onPressed: () => Navigator.of(context).pop(false)
        )
      ],
    );
  }
}
