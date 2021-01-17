import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/data/progress.dart';
import '../../services/data/progress_record.dart';
import '../../services/data/wallet.dart';
import '../../services/topics/index.dart';

class PurchaseTopicDialog extends StatelessWidget {
  final Topic topic;

  const PurchaseTopicDialog(
    this.topic, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Plant Seed'),
        content: Text('Use ${topic.cost} ${topic.cost == 1 ? 'seed' : 'seeds'} '
            'to start studying the topic "${topic.name}?"'),
        actions: <Widget>[
          TextButton(
            child: const Text('CONTINUE'),
            onPressed: () {
              if (Provider.of<WalletData>(context, listen: false)
                  .spend(topic.cost)) {
                Provider.of<ProgressData>(context, listen: false)
                    .createProgressRecord(ProgressRecord(topic.id));
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context).pop(false);
              }
            },
          ),
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      );
}
