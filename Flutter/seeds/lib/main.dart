import 'package:flutter/material.dart';
import 'package:seeds/pages/activity.dart';
import 'package:seeds/pages/plant.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        accentColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/plant',
      routes: {
        '/plant': (context) => PlantPage(),
        '/plant/activity': (context) => ActivityPage(),
      },
    );
  }
}
