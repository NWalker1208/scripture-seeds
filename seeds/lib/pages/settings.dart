import 'package:flutter/material.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/widgets/dialogs/erase_journal.dart';
import 'package:seeds/widgets/dialogs/reset_progress.dart';
import 'package:seeds/widgets/theme_mode_selector.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings')
      ),

      body: Builder(
        builder: (scaffoldContext) => Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: <Widget>[
              // Theme Dropdown
              Row(
                children: <Widget>[
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text('App Theme'),
                  )),
                  SizedBox(width: 12.0),
                  ThemeModeSelector()
                ],
              ),
              SizedBox(height: 12.0,),

              // Reset Progress Button
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () => eraseJournal(scaffoldContext),
                      child: Text('Erase Journal', style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)),
                      color: Theme.of(context).errorColor
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () => resetProgress(scaffoldContext),
                      child: Text('Reset Progress', style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)),
                      color: Theme.of(context).errorColor
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
