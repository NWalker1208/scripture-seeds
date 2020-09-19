import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:seeds/widgets/dashboard/indicators/daily_progress.dart';
import 'package:seeds/widgets/plant/button.dart';

class PlantsDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dashboard item title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Plants'),
            DailyProgressIndicator()
          ],
        ),

        // Plant list
        SizedBox(
          height: 150,
          child: Consumer<Library>(
            builder: (context, library, child) => ListView.builder(
              padding: EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              itemCount: library.topics.length,
              itemBuilder: (context, index) => PlantButton(library.topics[index])
            ),
          ),
        )
      ],
    );
  }
}
