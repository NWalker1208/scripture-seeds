import 'package:flutter/material.dart';

class PlantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faith")
      ),
      body: Text("Image"),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.opacity),
            title: Text('Water')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            title: Text('Share')
          )
        ]
      ),
    );
  }
}
