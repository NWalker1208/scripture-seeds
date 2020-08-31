import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/widgets/plant_status.dart';
import 'package:seeds/widgets/plant_view.dart';

class PlantButton extends StatelessWidget {
  final String topic;
  final double height;

  PlantButton(this.topic, {this.height = 0, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      textColor: Colors.white,

      onPressed: () => Navigator.of(context).pushNamed(
        '/plant',
        arguments: topic
      ),

      child: PlantView(
        topic,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height),
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

