import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/data/progress.dart';
import '../../services/data/wallet.dart';
import '../../services/topics/index.dart';

class RemovePlantDialog extends StatelessWidget {
  final Topic topic;

  const RemovePlantDialog(
    this.topic, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Remove Plant'),
        content:
            Text('Are you sure you want to remove your plant for the topic '
                '"${topic.name}?"\n\nYou will receive a seed, but you will '
                'also lose any progress for this topic.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('CONTINUE'),
            onPressed: () {
              if (Provider.of<ProgressData>(context, listen: false)
                  .removeProgressRecord(topic.id)) {
                Provider.of<WalletData>(context, listen: false).give(1);
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context).pop(false);
              }
            },
          ),
          RaisedButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      );
}
