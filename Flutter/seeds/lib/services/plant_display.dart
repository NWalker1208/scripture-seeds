import 'package:flutter/material.dart';
import 'package:seeds/services/database_manager.dart';
import 'package:seeds/services/plant_painter.dart';
import 'package:seeds/services/progress_record.dart';

class PlantDisplay extends StatefulWidget {
  final String plantName;

  PlantDisplay({Key key, this.plantName}) : super(key: key);

  @override
  _PlantDisplayState createState() => _PlantDisplayState();
}

class _PlantDisplayState extends State<PlantDisplay> {
  int progress;

  void getProgress() async {
    DatabaseManager db = await DatabaseManager.getDatabase();
    ProgressRecord record = await db.getProgress(widget.plantName);
    setState(() {
      progress = record.progress;
    });
  }

  @override
  void initState() {
    super.initState();
    progress = 0;
    getProgress();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PlantPainter(progress),
      child: Container(),
    );
  }
}

