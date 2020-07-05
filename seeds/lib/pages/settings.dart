import 'package:flutter/material.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/widgets/theme_mode_selector.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {

  void eraseJournal(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) =>
            AlertDialog(
              title: Text('Erase Journal'),
              content: Text('Are you sure you want to erase your study journal? This cannot be undone.'),

              actions: <Widget>[
                // Reset progress if user selects yes
                new FlatButton(child: Text('Yes'), onPressed: () {
                  Navigator.pop(dialogContext);

                  JournalData progressData = Provider.of<JournalData>(context, listen: false);
                  progressData.deleteAllEntries();

                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Your journal has been erased.'),
                  ));
                }),

                // Close dialog if user selects no
                new RaisedButton(child: Text('No'), onPressed: () => Navigator.pop(context),)
              ],
            )
    );
  }

  void resetProgress(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) =>
        AlertDialog(
          title: Text('Reset Progress'),
          content: Text('Are you sure you want to reset your progress? This cannot be undone.'),

          actions: <Widget>[
            // Reset progress if user selects yes
            new FlatButton(child: Text('Yes'), onPressed: () {
              Navigator.pop(dialogContext);

              ProgressData progressData = Provider.of<ProgressData>(context, listen: false);
              progressData.resetProgress();

              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Your progress has been reset.'),
              ));
            }),

            // Close dialog if user selects no
            new RaisedButton(child: Text('No'), onPressed: () => Navigator.pop(context),)
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings')
      ),

      body: Builder(
        builder: (scaffoldContext) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              // Theme Dropdown
              Row(
                children: <Widget>[
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('App Theme'),
                  )),
                  SizedBox(width: 8),
                  ThemeModeSelector()
                ],
              ),
              SizedBox(height: 8,),

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
                  SizedBox(width: 5,),
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
