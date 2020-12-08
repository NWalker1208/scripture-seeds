import 'package:flutter/material.dart';

import '../nav_list.dart';
import 'list.dart';

class PlantSelectDrawer extends StatelessWidget {
  final String currentPlant;

  PlantSelectDrawer(this.currentPlant, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Center(
                child: Text(
                  'Scripture Seeds',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlantList(currentPlant),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NavigationList(),
                ),
              ],
            ),
          ],
        ),
      );
}
