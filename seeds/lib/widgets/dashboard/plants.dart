import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/services/progress_record.dart';
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
          child: Consumer2<ProgressData, Library>(
            builder: (context, progress, library, child) {
              // Sort records so that incomplete ones go first
              List<ProgressRecord> records = progress.recordsWithTopics(library.topics)..sort();

              // If no plants are started, show a message
              if (records.length == 0)
                return Center(child: Text('Select a topic below to begin.'));

              return ListView.separated(
                padding: EdgeInsets.all(8),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: records.length,

                separatorBuilder: (context, index) => SizedBox(width: 8),
                itemBuilder: (context, index) => AspectRatio(
                  aspectRatio: 3/5,
                  child: PlantButton(records[index].name)
                ),
              );
            }
          ),
        )
      ],
    );
  }
}
