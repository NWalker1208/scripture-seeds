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

  void purchase(WalletData wallet, ProgressData progress, String topic, int price) {
    if (wallet.spend(price)) {
      progress.createProgressRecord(ProgressRecord(topic));
    } else {
      print('Not enough funds to purchase "$topic"');
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

        return Text.rich(
          TextSpan(
              children: List.generate(
                maxToShow == 0 ? topics.length : min(maxToShow, topics.length),
                (index) {
                  int price = library.topicPrices[topics[index]];

                  return WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: RaisedButton(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('$price '),
                            const ImageIcon(AssetImage('assets/seeds_icon.ico')),
                            Text(' ${topics[index].capitalize()}')
                          ],
                        ),

                        textColor: Colors.white,
                        disabledColor: Theme.of(context).scaffoldBackgroundColor,

                        onPressed: wallet.canAfford(price) ?
                          () => purchase(wallet, progress, topics[index], price) : null,
                      ),
                    )
                  );
                }
              )
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}

