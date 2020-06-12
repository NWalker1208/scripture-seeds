import 'package:flutter/material.dart';
import 'package:seeds/widgets/activities/activity_widget.dart';

class PonderActivity extends ActivityWidget {
  PonderActivity(String topic, {void Function(bool) onProgressChange, Key key}) :
        super(topic, onProgressChange: onProgressChange, key: key);

  @override
  _PonderActivityState createState() => _PonderActivityState();
}

class _PonderActivityState extends State<PonderActivity> {
  @override
  Widget build(BuildContext context) {
    return Center(
      // TODO: Replace with text box to write thoughts
      child: RaisedButton(
        child: Text('Continue'),
        onPressed: () => widget.onProgressChange(true),
      ),
    );
  }
}

