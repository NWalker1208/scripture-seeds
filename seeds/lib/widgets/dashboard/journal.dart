import 'package:flutter/material.dart';
import 'package:seeds/widgets/dashboard/indicators/streak.dart';

class JournalDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dashboard item title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Topics'),
            StreakIndicator()
          ],
        ),

        // Plant list
        Text('Smart journal')
      ],
    );
  }
}
