import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/data/journal.dart';

class EraseJournalDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Erase Journal'),
      content: Text('Are you sure you want to erase your study journal? This cannot be undone.'),

      actions: <Widget>[
        // Reset progress if user selects yes
        FlatButton(child: Text('CONTINUE'), onPressed: () {
          Navigator.of(context).pop(true);
          Provider.of<JournalData>(context, listen: false).deleteAllEntries();
        }),

        // Close dialog if user selects no
        RaisedButton(child: Text('CANCEL'), onPressed: () => Navigator.of(context).pop(false))
      ],
    );
  }
}
