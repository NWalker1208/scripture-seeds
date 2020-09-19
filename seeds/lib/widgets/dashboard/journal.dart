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
            Text('Journal'),
            StreakIndicator()
          ],
        ),

        // Plant list
        RaisedButton(
          child: Text('Open Journal'),
          onPressed: () => Navigator.of(context).pushNamed('/journal'),
        )
      ],
    );
  }
}
