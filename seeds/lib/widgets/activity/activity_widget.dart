import 'dart:async';
import 'package:flutter/material.dart';

import '../../services/topics/index.dart';

abstract class ActivityWidget extends StatefulWidget {
  final Topic topic;
  final FutureOr<void> Function(bool) onProgressChange;
  final bool activityCompleted;

  ActivityWidget(
    this.topic, {
    this.onProgressChange,
    this.activityCompleted = false,
    Key key,
  }) : super(key: key);

  String getHelpText();
}
