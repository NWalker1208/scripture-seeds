import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/data/progress.dart';
import 'package:seeds/widgets/plant/status.dart';
import 'package:seeds/widgets/plant/view.dart';

class PlantButton extends StatelessWidget {
  final String topic;

  PlantButton(this.topic, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.zero,
      highlightElevation: 6,
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      textColor: Colors.white,

      onPressed: () => Navigator.of(context).pushNamed(
        '/plant',
        arguments: topic
      ),

      child: PlantView(
        topic,
        plantPadding: EdgeInsets.fromLTRB(20, 20, 20, Theme.of(context).buttonTheme.height + 4),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<ProgressData>(
              builder: (context, progress, child) =>
                PlantStatus(progress.getProgressRecord(topic))
            ),
          ),
        )
      )
    );
  }
}

