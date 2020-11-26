import 'package:flutter/material.dart';
import 'package:seeds/widgets/topic_list.dart';
import 'package:seeds/widgets/dashboard/indicators/wallet.dart';

class TopicsDashboard extends StatelessWidget {
  const TopicsDashboard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dashboard item title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Topics', style: Theme.of(context).textTheme.subtitle1),
              const WalletIndicator(),
            ],
          ),
          const SizedBox(height: 8.0),

          // Plant list
          const TopicList(maxToShow: 5),
          const SizedBox(height: 8.0),

          FlatButton(
            child: Text('View All'),
            onPressed: () => Navigator.of(context).pushNamed('/topics'),
          ),
        ],
      ),
    );
  }
}
