import 'package:flutter/material.dart';
import 'package:seeds/widgets/topic_list.dart';
import 'package:seeds/widgets/dashboard/indicators/wallet.dart';

class TopicsDashboard extends StatelessWidget {
  const TopicsDashboard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Dashboard item title
        const ListTile(
          title: const Text('Topics'),
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
}
