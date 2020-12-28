import 'package:flutter/material.dart';

import '../widgets/dashboard/indicators/wallet.dart';
import '../widgets/topics/list.dart';

class TopicsPage extends StatelessWidget {
  const TopicsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('All Topics'),
          actions: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: WalletIndicator(),
            ),
          ],
        ),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TopicList(),
            ),
          ],
        ),
      );
}
