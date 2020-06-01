import 'package:flutter/material.dart';
import 'package:seeds/services/custom_icons.dart';
import 'package:seeds/widgets/plant_list.dart';
import 'package:share/share.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/widgets/plant_painter.dart';
import 'package:provider/provider.dart';

class PlantPage extends StatelessWidget {
  static final String defaultPlant = 'faith';
  final String plantName;

  PlantPage(plantName, {Key key}) :
      plantName = (plantName == null) ? defaultPlant : plantName,
      super(key: key);

  // Opens a dialog for when today's activity has already been completed
  void openActivityDialog(BuildContext context) {
    showDialog(
      context: context,

      builder: (_) => AlertDialog(
        title: Text('Daily Activity'),
        content: Text('You can\'t water this plant again until tomorrow. Would you like to do an activity anyways?'),

        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              openActivity(context);
            }
          ),

          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop()
          ),
        ],
      ),

      barrierDismissible: true,
    );
  }

  void openActivity(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/plant/activity',
      arguments: plantName
    );
  }

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
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Text(
                      "My Garden",
                      style: Theme.of(context).textTheme.headline5.merge(TextStyle(
                        color: Colors.white
                      ))
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.settings),
                      color: Colors.white,
                      tooltip: 'Settings',
                      onPressed: () => Navigator.pushNamed(context, '/settings'),
                    ),
                  ),
                ],
              ),
            ),

            PlantList(plantName)
          ],
        )
      ),

      // Body area of scaffold with plant image
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
        child:  Consumer<ProgressData>(
          builder: (context, progressData, child) {
            int progress = progressData.getProgressRecord(plantName).progress;

            return CustomPaint(
              painter: PlantPainter(progress),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Title (plantName)
                    child,

                    // Progress bar
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                      child: LinearPercentIndicator(
                        backgroundColor: Colors.green[700].withAlpha(80),
                        progressColor: Colors.green,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        animation: true,
                        animationDuration: 500,

                        leading: Text('${(progress/14 * 100).round()} %'),
                        trailing: Icon(Icons.flag),

                        percent: progress / 14.0,
                      ),
                    )
                  ],
                ),
              ),
            );
          },

          child: Text(
            plantName,
            style: Theme.of(context).textTheme.headline3.merge(TextStyle(
              fontFamily: 'Scriptina',
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
            ))
          )
        )
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Consumer<ProgressData>(
        builder: (context, progressData, child) {
          bool canMakeProgress = progressData.getProgressRecord(plantName).canMakeProgressToday;

          return FloatingActionButton(
            child: Icon(CustomIcons.water_drop),
            backgroundColor: canMakeProgress ? Theme.of(context).accentColor : Colors.grey[500],
            onPressed: () {
              if (!canMakeProgress)
                openActivityDialog(context);
              else
                openActivity(context);
            }
          );
        },
      ),

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () => Navigator.popAndPushNamed(context, '/'),
            ),
            Consumer<ProgressData>(
              builder: (context, progressData, child) => IconButton(
                icon: Icon(Icons.share),
                onPressed: () => Share.share('Day ${progressData.getProgressRecord(plantName).progress} of 14 on $plantName!', subject: 'Seeds'),
              ),
            )
          ],
        )
      )
    );
  }
}
