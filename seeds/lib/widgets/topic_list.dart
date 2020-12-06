import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/data/progress.dart';
import 'package:seeds/services/data/progress_record.dart';
import 'package:seeds/services/data/wallet.dart';
import 'package:seeds/services/library/library.dart';
import 'package:seeds/services/library/manager.dart';
import 'package:seeds/services/utility.dart';

class TopicList extends StatelessWidget {
  final int maxToShow;

  const TopicList({
    this.maxToShow = 0,
    Key key
  }) : super(key: key);

  bool purchase(WalletData wallet, ProgressData progress, String topic, int price) {
    if (wallet.spend(price)) {
      progress.createProgressRecord(ProgressRecord(topic));
      return true;
    } else {
      print('Not enough funds to purchase "$topic"');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<LibraryManager, ProgressData, WalletData>(
      builder: (context, libManager, progress, wallet, child) {
        Library library = libManager.library;

        // Check if library is still loading
        if (library == null)
          return const Text('Loading...', textAlign: TextAlign.center);

        List<String> topics = library.topicsSorted;
        List<String> topicsAlreadyPurchased = progress.recordNames;
        topics.removeWhere((t) => topicsAlreadyPurchased.contains(t));

        // Show message if all topics are purchased
        /*if (topics.length == 0)
          return const Text('You\'ve collected every topic!', textAlign: TextAlign.center);

        // Show message if unable to purchase topics
        if (wallet.availableFunds == 0)
          return const Text('Collect seeds to start new topics.', textAlign: TextAlign.center);*/

        if (maxToShow != 0)
          topics = topics.sublist(0, maxToShow);



        return Wrap(
          spacing: 8.0,
          alignment: WrapAlignment.center,
          children: [
            ...topics.map(
              (topic) =>
                ActionChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${library.topicPrices[topic]}'),
                      const SizedBox(width: 4),
                      const ImageIcon(AssetImage('assets/seeds_icon.ico')),
                      const SizedBox(width: 4),
                      Text(topic),
                    ],
                  ),

                  /*backgroundColor: Colors.transparent,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: DefaultTextStyle.of(context).style.color,
                    ),
                  ),*/

                  onPressed: () {
                    if (!purchase(wallet, progress, topic, library.topicPrices[topic]))
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Collect seeds to buy more topics.')
                        )
                      );
                  },
                )
            )
          ],
        );
      },
    );
  }
}

