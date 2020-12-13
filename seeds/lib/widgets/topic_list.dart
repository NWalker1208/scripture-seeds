import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/custom_icons.dart';
import '../services/data/progress.dart';
import '../services/data/progress_record.dart';
import '../services/data/wallet.dart';
import '../services/library/manager.dart';
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
      Consumer3<LibraryManager, ProgressData, WalletData>(
        builder: (context, libManager, progress, wallet, child) {
          var library = libManager.library;

          // Check if library is still loading
          if (library == null) {
            return const Text('Loading...', textAlign: TextAlign.center);
          }

          var topics = library.topics.toList();
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
                  curve: Curves.easeOut,
                ),
                child: ActionChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${library.topicPrices[topic]}'),
                      const SizedBox(width: 4),
                      const Icon(CustomIcons.seeds),
                      const SizedBox(width: 8),
                      Text(topic),
                    ],
                  ),
                  onPressed: () {
                    if (!purchase(
                        wallet, progress, topic, library.topicPrices[topic])) {
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
