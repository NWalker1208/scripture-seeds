import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/journal_data.dart';

class EraseJournalDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Erase Journal'),
      content: Text('Are you sure you want to erase your study journal? This cannot be undone.'),

      actions: <Widget>[
        // Reset progress if user selects yes
        new FlatButton(child: Text('Yes'), onPressed: () {
          Navigator.of(context).pop(true);

          JournalData progressData = Provider.of<JournalData>(context, listen: false);
          progressData.deleteAllEntries();
        }),

        // Close dialog if user selects no
        new RaisedButton(child: Text('No'), onPressed: () => Navigator.of(context).pop(false))
      ],
    );
  }
}
