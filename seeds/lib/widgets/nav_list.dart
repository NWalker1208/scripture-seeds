import 'package:flutter/material.dart';

class NavigationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right:16.0),
                child: Icon(Icons.home),
              ),
              Expanded(child: Text('Home')),
            ],
          ),

          onPressed: () { Navigator.pop(context); Navigator.pop(context); },
        ),

        FlatButton(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right:16.0),
                child: Icon(Icons.settings),
              ),
              Expanded(child: Text('Settings')),
            ],
          ),

          onPressed: () => Navigator.pushNamed(context, '/settings'),
        )
      ],
    );
  }
}
