import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RaisedButton(
            child: const Text('Sync Library'),
            onPressed: () => _resetLibraryCache(context),
            textColor: Colors.white
        ),

        // Reset Progress Button
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                  child: const Text('Erase Journal'),
                  onPressed: () => _eraseJournal(context),
                  textColor: Colors.white,
                  color: Theme.of(context).errorColor
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: RaisedButton(
                  child: const Text('Reset Progress'),
                  onPressed: () => _resetProgress(context),
                  textColor: Colors.white,
                  color: Theme.of(context).errorColor
              ),
            ),
          ],
        ),
      ],
    );
  }
}
