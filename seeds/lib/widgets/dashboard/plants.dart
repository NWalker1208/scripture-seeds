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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Plants', style: Theme.of(context).textTheme.subtitle1),
              DailyProgressIndicator()
            ],
          ),
        ),

        // Plant list
        SizedBox(
          height: 250,
          child: Consumer<Library>(
            builder: (context, library, child) => ListView.separated(
              padding: EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              itemCount: library.topics.length,

              separatorBuilder: (context, index) => SizedBox(width: 8),
              itemBuilder: (context, index) => AspectRatio(
                aspectRatio: 3/5,
                child: PlantButton(library.topics[index])
              ),
            ),
          ),
        )
      ],
    );
  }
}
