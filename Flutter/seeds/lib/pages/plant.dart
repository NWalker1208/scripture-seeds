import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:seeds/services/database_manager.dart';
import 'package:seeds/services/progress_record.dart';
import 'package:seeds/services/plant_painter.dart';

class PlantPage extends StatefulWidget {
  final String plantName;

  PlantPage(this.plantName, {Key key}) : super(key: key);

  @override
  _PlantPageState createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  int progress = 0;
  bool canMakeProgress = true;

  void getProgress() async {
    DatabaseManager db = await DatabaseManager.getDatabase();

    if (db.isOpen) {
      ProgressRecord record = await db.getProgress(widget.plantName);

      setState(() {
        progress = (record != null) ? record.progress : 0;
        canMakeProgress = (record != null) ? record.canMakeProgressToday : true;
      });

      await db.close();
    }
  }

  // Opens a dialog for when today's activity has already been completed
  void openActivityDialog() {
    showDialog(
      context: context,

      builder: (_) => AlertDialog(
        title: Text('Daily Activity'),
        content: Text('You can\'t water your plant again until tomorrow. Would you like to do an activity anyways?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () => Navigator.of(context).popAndPushNamed('/plant/activity').then(
                (value) {
                if (value == true)
                  getProgress();
              }
            )
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
        child:  CustomPaint(
          painter: PlantPainter(progress),
          child: Container(
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                widget.plantName,
                style: Theme.of(context).textTheme.headline3.merge(TextStyle(
                  fontFamily: 'Scriptina',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
                ))
              ),
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
            Navigator.pushNamed(context, '/plant/activity').then(
                (value) {
                  if (value == true)
                    getProgress();
                }
            );
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
                if (await DatabaseManager.deleteDatabase()) {
                  print('Deleted database file');
                  getProgress();
                } else
                  print('Database file does not exist');
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
