import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/data/progress.dart';
import '../../services/library/manager.dart';
import 'status.dart';

class PlantList extends StatelessWidget {
  final String currentlyOpen;

  PlantList(this.currentlyOpen, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer2<ProgressData, LibraryManager>(
        builder: (context, progress, libManager, child) {
          var records = progress.recordsWithTopics(libManager.library.topics)
            ..sort();

          // This column will build the list of plants based on progressData
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            // Children will be made from the list of topics
            children: records.map(
              (record) {
                // Create an onPressed event if the topic is not currently open
                var onPressed = () => Navigator.of(context)
                    .pushReplacementNamed('/plant', arguments: record.name);

                if (record.name == currentlyOpen) onPressed = null;

                // Choose a color based on the theme
                var selectedColor =
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.green[800]
                        : Colors.green[300];

                return FlatButton(
                  disabledTextColor: selectedColor,
                  onPressed: onPressed,
                  child: PlantStatus(record),
                );
              },
            ).toList(),
          );
        },
      );
}
