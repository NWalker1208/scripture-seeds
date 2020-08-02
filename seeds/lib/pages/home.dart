import 'package:flutter/material.dart';
import 'package:seeds/services/library/library.dart';
import 'package:seeds/widgets/plant_preview.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> topics = Library.topics.keys.toList();

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: topics.map((topic) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlantPreview(topic),
                  );
                }).toList(),
              ),
            ),

            Divider(),

            RaisedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/journal'),
              icon: Icon(Icons.book),
              label: Text('Study Journal'),
              textColor: Colors.white,
            )
          ],
        )
      ),
    );
  }
}

