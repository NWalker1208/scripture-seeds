import 'package:flutter/material.dart';

import '../topic_list.dart';
import 'indicators/wallet.dart';

class TopicsDashboard extends StatelessWidget {
  const TopicsDashboard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dashboard item title
          const ListTile(
            title: Text('Topics'),
            trailing: WalletIndicator(),
          ),

          // Plant list
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TopicList(maxToShow: 8),
          ),

          ListTile(
            title: const Text('View All', textAlign: TextAlign.center),
            onTap: () => Navigator.of(context).pushNamed('/topics'),
          ),
        ],
      );
}
