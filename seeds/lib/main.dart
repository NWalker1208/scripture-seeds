import 'package:flutter/material.dart';

import 'app.dart';
import 'hive.dart';
import 'providers.dart';

void main() async {
  await hiveInitialization();
  runApp(const AppProviders(SeedsApp()));
}
