import 'package:flutter/material.dart';

import '../dialogs/erase_journal.dart';
import '../dialogs/reset_progress.dart';

class DataManagementSettings extends StatelessWidget {
  const DataManagementSettings({Key key}) : super(key: key);

  void _eraseJournal(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const EraseJournalDialog(),
    ).then((erased) {
      if (erased ?? false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your journal has been erased.')),
        );
      }
    });
  }

  void _resetProgress(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const ResetProgressDialog(),
    ).then((didReset) {
      if (didReset ?? false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your progress has been reset.')),
        );
        
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
      }
    });
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: ListTile(
          leading: const Icon(Icons.delete_forever),
          title: const Text('Erase Journal'),
          tileColor: Theme.of(context).errorColor.withOpacity(0.8),
          onTap: () => _eraseJournal(context),
        ),
      ),
      Expanded(
        child: ListTile(
          leading: const Icon(Icons.undo_rounded),
          title: const Text('Reset Progress'),
          tileColor: Theme.of(context).errorColor.withOpacity(0.8),
          onTap: () => _resetProgress(context),
        ),
      ),
    ],
  );
}
