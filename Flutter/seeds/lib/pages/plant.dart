import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seeds/widgets/plant_list.dart';
import 'package:share/share.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:seeds/services/database_manager.dart';
import 'package:seeds/services/progress_record.dart';
import 'package:seeds/widgets/plant_painter.dart';

class PlantPage extends StatefulWidget {
  static final String defaultPlant = 'faith';
  final String plantName;

  PlantPage(plantName, {Key key}) :
      plantName = (plantName == null) ? defaultPlant : plantName,
      super(key: key);

  @override
  _PlantPageState createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  int progress = 0;
  bool canMakeProgress = true;

  void getProgress() {
    print('Getting progress for plant view...');
    ProgressRecord record = DatabaseManager.getProgressRecord(widget.plantName);

    if (DatabaseManager.isLoaded) {
      print('Using cached database progress.');
      setState(() {
        progress = (record != null) ? min(record.progress, 14) : 0;
        canMakeProgress = (record != null) ? record.canMakeProgressToday : true;
      });
    } else {
      print('Database has not been loaded. Retrieving data...');
      DatabaseManager.loadData().then((e) => getProgress());
    }
  }

  // Opens a dialog for when today's activity has already been completed
  void openActivityDialog() {
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
              openActivity();
            }
          ),

          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop()
          ),
        ],

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
      ),

      barrierDismissible: true,
    );
  }

  void openActivity() {
    Navigator.pushNamed(
      context,
      '/plant/activity',
      arguments: widget.plantName
    ).then(
        (value) {
        if (value == true)
          getProgress();
      }
    );
  }

  @override
  void initState() {
    super.initState();
    getProgress();
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
              child: Center(
                child: Text(
                  "My Garden",
                  style: Theme.of(context).textTheme.headline5.merge(TextStyle(
                    color: Colors.white
                  ))
                ),
              ),
            ),

            PlantList(widget.plantName)
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
        child:  CustomPaint(
          painter: PlantPainter(progress),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.plantName,
                  style: Theme.of(context).textTheme.headline3.merge(TextStyle(
                    fontFamily: 'Scriptina',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
                  ))
                ),

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
        )
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.opacity),
        backgroundColor: canMakeProgress ? Theme.of(context).accentColor : Colors.grey[500],
        onPressed: () {
          if (!canMakeProgress)
            openActivityDialog();
          else
            openActivity();
        }
      ),

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () async {
                DatabaseManager.resetProgress();
                getProgress();
                /*if (await DatabaseManager.deleteDatabase()) {
                  print('Deleted database file');
                  getProgress();
                } else
                  print('Database file does not exist');*/
              },
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share('Day $progress of 14 on faith!', subject: 'Seeds');
              },
            )
          ],
        )
      )
    );
  }
}
