import 'package:flutter/material.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/wallet.dart';

class ResetProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reset Progress'),
      content: Text('Are you sure you want to reset your progress? This cannot be undone.'),

      actions: <Widget>[
        // Reset progress if user selects yes
        FlatButton(child: Text('CONTINUE'), onPressed: () {
          Navigator.of(context).pop(true);

          ProgressData progress = Provider.of<ProgressData>(context, listen: false);
          progress.resetProgress();

          WalletData wallet = Provider.of<WalletData>(context, listen: false);
          wallet.reset();
        }),

        // Close dialog if user selects no
        RaisedButton(child: Text('CANCEL'), onPressed: () => Navigator.of(context).pop(false))
      ],
    );
  }
}
