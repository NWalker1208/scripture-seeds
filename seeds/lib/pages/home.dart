import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:seeds/widgets/plant_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Library>(
        builder: (context, library, child) => CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 150,
              pinned: true,
              stretch: true,

              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.all(16),
                title: Text('My Garden'),
                stretchModes: [StretchMode.fadeTitle],
              ),

              actions: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                  icon: Icon(Icons.settings),
                )
              ],
            ),

            SliverList(
              delegate: SliverChildListDelegate(
                library.topics?.map((topic) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlantButton(topic),
                  );
                })?.toList() ?? []
              ),
            )
          ]
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/journal'),
            icon: Icon(Icons.book),
            label: Text('Study Journal'),
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

