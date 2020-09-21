import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/services/progress_record.dart';
import 'package:seeds/services/wallet.dart';
import 'package:seeds/widgets/dashboard/indicators/wallet.dart';
import 'package:seeds/services/utility.dart';

class TopicsDashboard extends StatelessWidget {
  void purchaseAndOpen(BuildContext context, String topic) {
    Provider.of<WalletData>(context, listen: false).spend(1);
    Provider.of<ProgressData>(context, listen: false).createProgressRecord(
      ProgressRecord(topic)
    );

    /*Navigator.of(context).pushNamed(
      '/plant',
      arguments: topic
    );*/
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
              if (wallet.availableFunds == 0)
                return Text('Collect seeds to start new topics.', textAlign: TextAlign.center,);

              return Text.rich(
                TextSpan(
                  children: List.generate(
                      library.topics.length,
                        (index) => WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: RaisedButton(
                            child: Text(library.topics[index].capitalize()),
                            textColor: Colors.white,
                            onPressed: () => purchaseAndOpen(context, library.topics[index]),
                          ),
                        )
                      )
                  )
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
