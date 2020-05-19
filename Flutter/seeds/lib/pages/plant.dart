import 'package:flutter/material.dart';
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
            )
          ],
        )
      ),

      backgroundColor: Colors.lightBlue[400],
      body: Container(
        decoration: BoxDecoration( gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.lightBlue[200],
            Colors.lightBlue[400],
          ]
        )),
        child: Center(
          child: Text('Hello World')
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/plant/activity');
        },
        backgroundColor: Colors.blue[700],
        child: Icon(Icons.opacity)
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
