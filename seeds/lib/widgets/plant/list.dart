import 'package:flutter/material.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:seeds/services/progress_record.dart';
import 'package:provider/provider.dart';
import 'package:seeds/widgets/plant/status.dart';

class PlantList extends StatelessWidget {
  final String currentlyOpen;

  PlantList(this.currentlyOpen, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProgressData, Library>(
      builder: (context, progress, library, child) {
        List<ProgressRecord> records = progress.records;
        records.removeWhere((record) => !library.topics.contains(record.name));

        return Column(
          // This column will build the list of plants based on the progressData stream
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          // Children will be made from the list of topics
          children: records.map((record) {
            // Create an onPressed event if the topic is not currently open
            var onPressed = () => Navigator.of(context).pushReplacementNamed(
              '/plant',
              arguments: record.name
            );

            if (record.name == currentlyOpen)
              onPressed = null;

            // Choose a color based on the theme for the item that is currently open
            Color selectedColor = Theme.of(context).brightness == Brightness.light ?
              Colors.green[800] :
              Colors.green[300];

            return FlatButton(
              disabledTextColor: selectedColor,
              onPressed: onPressed,
              child: PlantStatus(record)
            );
          }).toList()
        );
      }
    );
  }
}

