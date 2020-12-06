import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:seeds/services/library/manager.dart';
import 'package:seeds/widgets/dialogs/erase_journal.dart';
import 'package:seeds/widgets/dialogs/reset_progress.dart';

class DataManagementSettings extends StatelessWidget {
  const DataManagementSettings({
    Key key,
  }) : super(key: key);

  void _resetLibraryCache(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshing study library...'),
      )
    );

    LibraryManager libManager = Provider.of<LibraryManager>(context, listen: false);

    libManager.refreshLibrary().then((_) => Scaffold.of(context).showSnackBar(
      const SnackBar(
        content: Text('Library sync complete.'),
      )
    ));
  }

  void _eraseJournal(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const EraseJournalDialog()
    ).then((bool erased) {
      if (erased ?? false)
        Scaffold.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your journal has been erased.'),
          )
        );
    });
  }

  void _resetProgress(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const ResetProgressDialog()
    ).then((bool didReset) {
      if (didReset ?? false)
        Scaffold.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your progress has been reset.'),
          )
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.refresh),
          title: const Text('Refresh Library'),
          subtitle: Consumer<LibraryManager>(
            builder: (context, libManager, child) {
              if (libManager.lastRefresh == null)
                return Text('Last refresh: Never');
              else
                return Text(
                  'Last refresh: ${DateFormat('h:mm a, M/d/yyyy').format(libManager.lastRefresh)}'
                );
            }
          ),
          onTap: () => _resetLibraryCache(context),
        ),

        Row(
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
        ),
      ],
    );
  }
}
