import 'package:flutter/material.dart';
import 'package:seeds/services/database_manager.dart';
import 'package:seeds/services/library.dart';
import 'package:seeds/services/progress_record.dart';
import 'package:seeds/services/utility.dart';

class PlantList extends StatelessWidget {
  final String currentlyOpen;

  PlantList(this.currentlyOpen, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> topics = Library.topics.keys.toList();

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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

          // Determine if the icon should show that the user should complete the daily activity
          ProgressRecord progress = DatabaseManager.getProgressRecord(topic);
          bool canMakeProgress = (progress == null) ? true : progress.canMakeProgressToday;

          return Row(
            children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                canMakeProgress ? Icons.error : Icons.done,
                color: onPressed == null ? selectedColor : null,
              ),
            ),
            Expanded(
                child: FlatButton(
                  onPressed: onPressed,
                  disabledTextColor: selectedColor,
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('${topic.capitalize()}', textAlign: TextAlign.left,)
                  ),
                ),
              )
            ],
          );
        }).toList()
      ),
    );
  }
}

