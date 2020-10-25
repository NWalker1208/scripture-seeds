import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/library/library.dart';
import 'package:seeds/services/data/progress.dart';
import 'package:seeds/services/data/progress_record.dart';
import 'package:seeds/services/data/wallet.dart';
import 'package:seeds/widgets/dashboard/indicators/wallet.dart';
import 'package:seeds/services/utility.dart';

class TopicsDashboard extends StatelessWidget {
  void purchase(WalletData wallet, ProgressData progress, String topic, int price) {
    if (wallet.spend(price)) {
      progress.createProgressRecord(ProgressRecord(topic));
    } else {
      print('Not enough funds to purchase "$topic"');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Dashboard item title
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Topics', style: Theme.of(context).textTheme.subtitle1),
              WalletIndicator()
            ],
          ),
        ),

        // Plant list
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer3<Library, ProgressData, WalletData>(
            builder: (context, library, progress, wallet, child) {
              List<String> topics = library.topicsSorted;
              List<String> topicsAlreadyPurchased = progress.recordNames;
              topics.removeWhere((t) => topicsAlreadyPurchased.contains(t));

              // Show message if all topics are purchased
              if (topics.length == 0)
                return Text('You\'ve collected every topic!', textAlign: TextAlign.center);

              // Show message if unable to purchase topics
              if (wallet.availableFunds == 0)
                return Text('Collect seeds to start new topics.', textAlign: TextAlign.center);

              return Text.rich(
                TextSpan(
                  children: List.generate(
                    topics.length,
                    (index) {
                      int price = library.priceOfTopic(topics[index]);

                      return WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: RaisedButton(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('$price '),
                                ImageIcon(AssetImage('assets/seeds_icon.ico')),
                                Text(' ${topics[index].capitalize()}')
                              ],
                            ),

                            textColor: Colors.white,
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
          ),
        )
      ],
    );
  }
}
