import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Activity"),
      ),
      body: Center(
        child: FlatButton(
          child: Text("Water Plant"),
          onPressed: () {Navigator.pop(context);}
        ),
      )
    );
  }
}
