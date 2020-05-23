import 'package:flutter/material.dart';
import 'package:seeds/services/plant_display.dart';
import 'package:share/share.dart';

class PlantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Plant')
      ),

      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                "My Garden",
                style: Theme.of(context).textTheme.headline6.merge(TextStyle(
                  color: Colors.white
                ))
              ),
            ),
          ],
        )
      ),

      backgroundColor: (Theme.of(context).brightness == Brightness.light ?
        Colors.lightBlue[200] :
        Colors.indigo[900]
      ),
      body: Container(
        decoration: BoxDecoration( gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: (
            Theme.of(context).brightness == Brightness.light ?
            <Color>[
              Colors.lightBlue[100],
              Colors.lightBlue[200],
            ] :
            <Color>[
              Colors.indigo[800],
              Colors.indigo[900],
            ]
          )
        )),
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,

        // Plant Display Region
        child: PlantDisplay(plantName: 'faith',)
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.opacity),
        onPressed: () {
          Navigator.pushNamed(context, '/plant/activity');
        }
      ),

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share('I\'m doing great!', subject: 'Faith');
              },
            )
          ],
        )
      )
    );
  }
}
