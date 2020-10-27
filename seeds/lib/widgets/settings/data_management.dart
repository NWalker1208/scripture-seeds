import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/library/manager.dart';
import 'package:seeds/widgets/dialogs/erase_journal.dart';
import 'package:seeds/widgets/dialogs/reset_progress.dart';

class DataManagementSettings extends StatelessWidget {
  void resetLibraryCache(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Refreshing study library...'),
      )
    );

    LibraryManager libManager = Provider.of<LibraryManager>(context, listen: false);

    libManager.refreshLibrary().then((_) => Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Library sync complete.'),
      )
    ));
  }

  void eraseJournal(BuildContext context) {
    showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (_) => EraseJournalDialog()
    ).then((bool erased) {
      if (erased ?? false)
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Your journal has been erased.'),
        ));
    });
  }

  void resetProgress(BuildContext context) {
    showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (_) => ResetProgressDialog()
    ).then((bool didReset) {
      if (didReset ?? false)
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Your progress has been reset.'),
        ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RaisedButton(
            child: Text('Sync Library'),
            onPressed: () => resetLibraryCache(context),
            textColor: Colors.white
        ),

        // Reset Progress Button
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                  child: Text('Erase Journal'),
                  onPressed: () => eraseJournal(context),
                  textColor: Colors.white,
                  color: Theme.of(context).errorColor
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: RaisedButton(
                  child: Text('Reset Progress'),
                  onPressed: () => resetProgress(context),
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
