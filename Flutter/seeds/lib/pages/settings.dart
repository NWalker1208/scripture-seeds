import 'package:flutter/material.dart';
import 'package:seeds/services/database_manager.dart';
import 'package:seeds/widgets/theme_mode_selector.dart';

class SettingsPage extends StatelessWidget {

  void resetProgress(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) =>
        AlertDialog(
          title: Text('Reset Progress'),
          content: Text('Are you sure you want to reset your progress? This cannot be undone.'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: <Widget>[
            new FlatButton(child: Text('Yes'), onPressed: () => Navigator.pop(context, true),),
            new RaisedButton(child: Text('No'), onPressed: () => Navigator.pop(context, false),)
          ],
        )
    ).then((doReset) {
      if (doReset == true) {
        if (DatabaseManager.isLoaded) {
          DatabaseManager.resetProgress();
          DatabaseManager.saveData();
        } else
          DatabaseManager.loadData().then((succeeded) {
            DatabaseManager.resetProgress();
            DatabaseManager.saveData();
          });

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Your progress has been reset.'),
        ));
      }
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
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              // Theme Dropdown
              Row(
                children: <Widget>[
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'App Theme',
                      style: Theme.of(context).textTheme.bodyText1
                    ),
                  )),
                  SizedBox(width: 8),
                  ThemeModeSelector()
                ],
              ),
              SizedBox(height: 8,),

              // Reset Progress Button
              RaisedButton(
                onPressed: () => resetProgress(scaffoldContext),
                child: Text('Reset Progress'),
                color: Colors.redAccent
              ),
            ],
          ),
        ),
      )
    );
  }
}
