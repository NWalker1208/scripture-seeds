import 'dart:async';
import 'package:flutter/material.dart';

abstract class ActivityWidget extends StatefulWidget {
  final String topic;
  final FutureOr<void> Function(bool) onProgressChange;
  final bool activityCompleted;

  ActivityWidget(this.topic, {this.onProgressChange, this.activityCompleted = false, Key key}) : super(key: key);

  Future<void> openInstructions(BuildContext context);
}
