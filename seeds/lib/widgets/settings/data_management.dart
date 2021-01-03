import 'package:flutter/material.dart';
import 'package:seeds/widgets/app_bar_themed.dart';

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
  Widget build(BuildContext context) => ListTileTheme.merge(
        tileColor: Theme.of(context).errorColor.withOpacity(0.95),
        child: AppBarThemed(Row(
          children: [
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Erase Journal'),
                onTap: () => _eraseJournal(context),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.undo_rounded),
                title: const Text('Reset Progress'),
                onTap: () => _resetProgress(context),
              ),
            ),
          ],
        )),
      );
}
