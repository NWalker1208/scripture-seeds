import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/data/journal.dart';

class EraseEntryDialog extends StatelessWidget {
  final Set<JournalEntry> entriesToDelete;

  EraseEntryDialog(this.entriesToDelete);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text('Erase Journal '
            '${entriesToDelete.length == 1 ? 'Entry' : 'Entries'}'),
        content: Text('Are you sure you want to delete '
            '${entriesToDelete.length == 1 ? 'this entry' : 'these entries'}'
            ' from your journal? This cannot be undone.'),
        actions: <Widget>[
          // Reset progress if user selects yes
          TextButton(
            child: Text('CONTINUE'),
            onPressed: () {
              Navigator.of(context).pop(true);
              Provider.of<JournalData>(context, listen: false)
                  .deleteEntrySet(entriesToDelete);
            },
          ),

          // Close dialog if user selects no
          ElevatedButton(
            child: Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(false),
          )
        ],
      );
}
