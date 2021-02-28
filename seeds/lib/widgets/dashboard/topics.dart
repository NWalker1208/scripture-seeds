import 'package:flutter/material.dart';

import '../../utility/go.dart';
import '../topics/list.dart';
import '../tutorial/focus.dart';
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
          const TutorialFocus(
            'dashboard',
            index: 1,
            overlayLabel: Text('Select a topic to begin.'),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TopicList(showPurchased: false, maxToShow: 8),
            ),
          ),

          ListTile(
            title: const Text('View All', textAlign: TextAlign.center),
            onTap: () => Go.from(context).toTopics(),
          ),
        ],
      );
}
