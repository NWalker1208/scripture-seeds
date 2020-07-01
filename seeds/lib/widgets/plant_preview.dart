import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/widgets/plant_painter.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/services/progress_record.dart';
import 'package:seeds/widgets/plant_view.dart';

class PlantPreview extends StatelessWidget {
  final String topic;

  PlantPreview(this.topic, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
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
            child: Text(topic),
          )
        )
      )
    );
  }
}

