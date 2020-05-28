import 'package:flutter/material.dart';
import 'package:seeds/pages/home.dart';
import 'package:seeds/pages/plant.dart';
import 'package:seeds/pages/activity.dart';
import 'package:seeds/pages/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seeds',

      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        accentColor: Colors.blue,
        textSelectionColor: Colors.green[500],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      initialRoute: '/',
      routes: {
        '/' : (context) => HomePage(),
        '/plant': (context) => PlantPage(ModalRoute.of(context).settings.arguments),
        '/plant/activity': (context) => ActivityPage(),
        '/settings' : (context) => SettingsPage(),
      },
    );
  }
}
