import 'package:flutter/material.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:seeds/services/progress_record.dart';
import 'package:seeds/services/utility.dart';
import 'package:provider/provider.dart';
import 'package:seeds/widgets/plant_status.dart';

class PlantList extends StatelessWidget {
  final String currentlyOpen;

  PlantList(this.currentlyOpen, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> topics = Provider.of<Library>(context, listen: false).topics.toList();

    return Consumer<ProgressData>(
      builder: (context, progressData, child) => Column(
        // This column will build the list of plants based on the progressData stream
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        // Children will be made from the list of topics
        children: topics.map((topic) {
          // Create an onPressed event if the topic is not currently open
          var onPressed = () => Navigator.of(context).pushReplacementNamed(
            '/plant',
            arguments: topic
          );

          if (topic == currentlyOpen)
            onPressed = null;

          // Choose a color based on the theme for the item that is currently open
          Color selectedColor = Theme.of(context).brightness == Brightness.light ?
            Colors.green[800] :
            Colors.green[300];

          ProgressRecord progress = progressData.getProgressRecord(topic);

          return FlatButton(
            padding: EdgeInsets.all(8.0),
            disabledTextColor: selectedColor,
            onPressed: onPressed,
            child: PlantStatus(progress)
          );
        }).toList()
      ),
    );
  }
}

