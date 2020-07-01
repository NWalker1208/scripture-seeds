import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:seeds/widgets/plant_view.dart';
import 'package:seeds/services/utility.dart';

class PlantPreview extends StatelessWidget {
  final String topic;

  PlantPreview(this.topic, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,

      onPressed: () => Navigator.of(context).pushNamed(
        '/plant',
        arguments: topic
      ),

      child: PlantView(
        topic,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(topic.capitalize(), style: Theme.of(context).textTheme.subtitle1,),
          )
        )
      )
    );
  }
}

