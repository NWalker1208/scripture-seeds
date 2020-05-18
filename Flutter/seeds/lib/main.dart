import 'package:flutter/material.dart';
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
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline1: TextStyle(fontFamily: 'Scriptina'),

          headline2: TextStyle(fontFamily: 'Scriptina'),

          headline3: TextStyle(fontFamily: 'Scriptina'),

          headline4: TextStyle(fontFamily: 'Scriptina'),

          headline5: TextStyle(fontFamily: 'Scriptina'),

          headline6: TextStyle(fontFamily: 'Scriptina'),

        )
      ),
//      darkTheme: ThemeData(
//        brightness: Brightness.dark,
//        primarySwatch: Colors.green,
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
      initialRoute: '/plant',
      routes: {
        '/plant': (context) => PlantPage()
      },
    );
  }
}
