import 'package:flutter/material.dart';
import 'package:seeds/widgets/plant_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Garden'),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: PlantList(''),
    );
  }
}

