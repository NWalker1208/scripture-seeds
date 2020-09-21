import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:seeds/widgets/dashboard/indicators/wallet.dart';
import 'package:seeds/services/utility.dart';

class TopicsDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          padding: const EdgeInsets.all(4.0),
          child: Consumer<Library>(
            builder: (context, library, child) => Text.rich(
              TextSpan(
               children: List.generate(
                 library.topics.length,
                 (index) => WidgetSpan(
                   child: Padding(
                     padding: const EdgeInsets.all(4.0),
                     child: RaisedButton(
                       child: Text(library.topics[index].capitalize()),
                       onPressed: () => {}, // TODO: Purchase topic
                     ),
                   )
                 )
               )
              )
            ),
          ),
        )
      ],
    );
  }
}
