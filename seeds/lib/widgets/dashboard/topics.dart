import 'package:flutter/material.dart';
import 'package:seeds/widgets/dashboard/indicators/wallet.dart';

class TopicsDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dashboard item title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Topics'),
            WalletIndicator()
          ],
        ),

        // Plant list
        Text('Topic list')
      ],
    );
  }
}
