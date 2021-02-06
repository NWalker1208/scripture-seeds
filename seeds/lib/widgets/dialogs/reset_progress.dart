import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/history/provider.dart';
import '../../services/progress/provider.dart';
import '../../services/tutorial/provider.dart';
import '../../services/wallet/provider.dart';

class ResetProgressDialog extends StatelessWidget {
  const ResetProgressDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text('Are you sure you want to reset your progress? '
            'This cannot be undone.'),
        actions: <Widget>[
          // Reset progress if user selects yes
          TextButton(
            child: const Text('CONTINUE'),
            onPressed: () {
              Provider.of<TutorialProvider>(context, listen: false).reset();
              Provider.of<ProgressProvider>(context, listen: false).reset();
              Provider.of<StudyHistory>(context, listen: false).clear();
              Provider.of<WalletProvider>(context, listen: false).reset();
              Navigator.of(context).pop(true);
            },
          ),

          // Close dialog if user selects no
          ElevatedButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(false),
          )
        ],
      );
}
