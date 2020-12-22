import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/custom_icons.dart';
import '../services/data/progress.dart';
import '../services/data/progress_record.dart';
import '../services/data/wallet.dart';
import '../services/topics/provider.dart';
import 'animated_list.dart';

class TopicList extends StatelessWidget {
  final int maxToShow;

  const TopicList({
    this.maxToShow = 0,
    Key key,
  }) : super(key: key);

  bool purchase(
    WalletData wallet,
    ProgressData progress,
    String topic,
    int price,
  ) {
    if (wallet.spend(price)) {
      progress.createProgressRecord(ProgressRecord(topic));
      return true;
    } else {
      print('Not enough funds to purchase "$topic"');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) =>
      Consumer3<TopicIndexProvider, ProgressData, WalletData>(
        builder: (context, topicIndex, progress, wallet, child) {
          // Check if library is still loading
          if (topicIndex.index == null) {
            return const Text('Loading...', textAlign: TextAlign.center);
          }

          var topics = topicIndex.index.topics.toList();
          topics.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

          var topicsAlreadyPurchased = progress.recordNames;
          topics.removeWhere((t) => topicsAlreadyPurchased.contains(t));

          if (maxToShow != 0) topics = topics.take(maxToShow).toList();

          // Show message if all topics are purchased
          if (topics.isEmpty) {
            return const Text(
              'You\'ve collected every topic!',
              textAlign: TextAlign.center,
            );
          }

          return AnimatedListBuilder<String>.list(
            items: topics,
            duration: const Duration(milliseconds: 200),
            childBuilder: (context, topic, animation) => FadeTransition(
              opacity: animation,
              child: SizeTransition(
                axis: Axis.horizontal,
                sizeFactor: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: ActionChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${topicIndex.index[topic].cost}'),
                      const SizedBox(width: 4),
                      const Icon(CustomIcons.seeds),
                      const SizedBox(width: 8),
                      Text(topicIndex.index[topic].name),
                    ],
                  ),
                  onPressed: () {
                    if (!purchase(
                      wallet,
                      progress,
                      topic,
                      topicIndex.index[topic].cost,
                    )) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Collect seeds to buy more topics.'),
                      ));
                    }
                  },
                ),
              ),
            ),
            viewBuilder: (context, children) => Wrap(
              spacing: 12.0,
              alignment: WrapAlignment.center,
              children: children,
            ),
          );
        },
      );
}
