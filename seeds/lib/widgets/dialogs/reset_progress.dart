import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/data/wallet.dart';
import '../../services/history/provider.dart';
import '../../services/progress/provider.dart';
import '../../services/settings/help.dart';
import '../help_info.dart';

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
              Navigator.of(context).pop(true);

              var help = Provider.of<HelpSettings>(context, listen: false);
              HelpInfoState.resetPagesShown();
              help.resetHelp();

              var progress =
                  Provider.of<ProgressProvider>(context, listen: false);
              progress.reset();

              var history = Provider.of<StudyHistory>(context, listen: false);
              history.clear();

              var wallet = Provider.of<WalletData>(context, listen: false);
              wallet.reset();
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
