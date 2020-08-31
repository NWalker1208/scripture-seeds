import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/instructions_settings.dart';

class InstructionsDialog extends StatelessWidget {
  final String instructions;

  InstructionsDialog(this.instructions, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Instructions"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(instructions),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<InstructionsSettings>(
                builder: (context, settings, child) =>
                  Checkbox(
                    value: settings.alwaysShow,
                    onChanged: (bool alwaysShow) => settings.alwaysShow = alwaysShow,
                  )
              ),

              Text("Always show instructions")
            ],
          )
        ],
      ),
      actions: [
        FlatButton(
          child: Text("Ok"),
          onPressed: () => Navigator.of(context).pop()
        ),
      ],
    );
  }
}
