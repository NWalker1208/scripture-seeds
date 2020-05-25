import 'package:flutter/material.dart';
import 'package:seeds/services/library.dart';
import 'package:seeds/services/utility.dart';

class PlantList extends StatelessWidget {
  final String currentlyOpen;

  PlantList(this.currentlyOpen, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> topics = Library.topics.keys.toList();
    int disableIndex = -1;

    if (currentlyOpen != null && topics.contains(currentlyOpen))
      disableIndex = topics.indexOf(currentlyOpen);

    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          var onPressed = () => Navigator.of(context).pushReplacementNamed(
            '/plant',
            arguments: topics[index]
          );

          if (index == disableIndex)
            onPressed = null;

          return FlatButton(
            onPressed: onPressed,

            child: Text('${topics[index].capitalize()}'),
          );
        }
      ),
    );
  }
}

