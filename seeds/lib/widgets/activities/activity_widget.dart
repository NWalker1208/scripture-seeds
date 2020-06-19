import 'package:flutter/material.dart';

abstract class ActivityWidget extends StatefulWidget {
  final String topic;
  final void Function(bool, String) onProgressChange;

  ActivityWidget(this.topic, {this.onProgressChange, Key key}) : super(key: key);
}
