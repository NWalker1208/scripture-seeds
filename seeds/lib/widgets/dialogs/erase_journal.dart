import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/journal/provider.dart';

class EraseJournalDialog extends StatelessWidget {
  const EraseJournalDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Erase Journal'),
        content:
            const Text('Are you sure you want to erase your study journal? '
                'This cannot be undone.'),
        actions: <Widget>[
          // Reset progress if user selects yes
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Provider.of<JournalProvider>(context, listen: false).deleteAll();
            },
            child: const Text('CONTINUE'),
          ),

          // Close dialog if user selects no
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          )
        ],
      );
}
