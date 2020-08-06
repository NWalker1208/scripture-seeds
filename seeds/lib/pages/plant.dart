import 'package:flutter/material.dart';
import 'package:seeds/services/custom_icons.dart';
import 'package:seeds/services/progress_record.dart';
import 'package:seeds/widgets/plant_list.dart';
import 'package:seeds/widgets/plant_view.dart';
import 'package:social_share/social_share.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:provider/provider.dart';

class PlantPage extends StatelessWidget {
  final String plantName;
  final int initialProgress;

  PlantPage({this.plantName = 'faith', this.initialProgress = 0, Key key}) : super(key: key);

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
    return PlantView(
      plantName,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Plant')
        ),

        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                child: Center(
                  child: Text(
                    "My Garden",
                    style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white)
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.all(8.0), child: Column(children: <Widget>[
                PlantList(plantName),

                Divider(thickness: 1, indent: 8, endIndent: 8,),

                FlatButton(
                  padding: EdgeInsets.all(8.0),
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
                  padding: EdgeInsets.all(8.0),
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

              ),),
            ],
          )
        ),

        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          // Plant Display Region
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Title (plantName)
              Text(
                plantName,
                style: Theme.of(context).textTheme.headline3.copyWith(
                  fontFamily: 'Scriptina',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
                )
              ),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                child: Consumer<ProgressData>(
                  builder: (context, progressData, child) {
                    ProgressRecord record = progressData.getProgressRecord(plantName);
                    int progress = record.progress, maxProgress = record.maxProgress;

                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: initialProgress/maxProgress, end: progress/maxProgress),
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeInOutCubic,

                      builder: (BuildContext context, double percent, Widget child) => LinearPercentIndicator(
                        backgroundColor: Colors.green[700].withAlpha(80),
                        progressColor: Colors.green,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        animation: false,

                        leading: Text('${(progress/maxProgress * 100).round()} %'),
                        trailing: Icon(Icons.flag),

                        percent: percent,
                      ),
                    );
                  }
                )
              )
            ],
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
                icon: Icon(Icons.book),
                onPressed: () => Navigator.pushNamed(context, '/journal'),
              ),
              Consumer<ProgressData>(
                builder: (context, progressData, child) {
                  ProgressRecord record = progressData.getProgressRecord(plantName);
                  return IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () => SocialShare.shareOptions('Day ${record.progress} of ${record.maxProgress} on $plantName!'),
                  );
                }
              )
            ],
          )
        )
      ),
    );
  }
}
