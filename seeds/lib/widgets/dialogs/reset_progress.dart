import 'package:flutter/material.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:provider/provider.dart';

class ResetProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reset Progress'),
      content: Text('Are you sure you want to reset your progress? This cannot be undone.'),

      actions: <Widget>[
        // Reset progress if user selects yes
        new FlatButton(child: Text('Yes'), onPressed: () {
          Navigator.of(context).pop(true);

          ProgressData progressData = Provider.of<ProgressData>(context, listen: false);
          progressData.resetProgress();
        }),

        // Close dialog if user selects no
        new RaisedButton(child: Text('No'), onPressed: () => Navigator.of(context).pop(false))
      ],
    );
  }
}
