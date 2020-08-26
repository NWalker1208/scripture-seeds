import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/widgets/plant_status.dart';
import 'package:seeds/widgets/plant_view.dart';
import 'package:seeds/services/utility.dart';

class PlantButton extends StatelessWidget {
  final String topic;

  PlantButton(this.topic, {Key key}) : super(key: key);

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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 100,),
              Consumer<ProgressData>(
                builder: (context, progressData, child) => PlantStatus(progressData.getProgressRecord(topic))
              ),
            ],
          ),
        )
      )
    );
  }
}

