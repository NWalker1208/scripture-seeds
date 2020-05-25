import 'package:flutter/material.dart';
import 'package:seeds/services/library.dart';
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
              var onPressed = () => Navigator.of(context).pushReplacementNamed(
                '/plant',
                arguments: topic
              );

              if (topic == currentlyOpen)
                onPressed = null;

              Color color = Theme.of(context).brightness == Brightness.light ?
                Colors.green[800] :
                Colors.green[300];

              return Row(
                children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    // TODO: Make this depend on if the daily activity has been completed.
                    false ? Icons.error : Icons.done,
                    color: onPressed == null ? color : null,
                  ),
                ),
                Expanded(
                    child: FlatButton(
                      onPressed: onPressed,
                      disabledTextColor: color,
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

