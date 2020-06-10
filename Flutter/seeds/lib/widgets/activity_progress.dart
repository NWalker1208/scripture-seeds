import 'package:flutter/material.dart';

class ActivityProgressMap extends StatelessWidget {
  final int progress;

  ActivityProgressMap(this.progress, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Progress $progress"),
        ),
      ],
    );
  }
}
