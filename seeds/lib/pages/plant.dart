import 'package:flutter/material.dart';
import 'package:seeds/services/custom_icons.dart';
import 'package:seeds/services/progress_record.dart';
import 'package:seeds/widgets/dialogs/extra_study.dart';
import 'package:seeds/widgets/help_page.dart';
import 'package:seeds/widgets/plant/drawer.dart';
import 'package:seeds/widgets/plant/list.dart';
import 'package:seeds/widgets/plant/progress_indicator.dart';
import 'package:seeds/widgets/plant/view.dart';
import 'package:social_share/social_share.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:provider/provider.dart';

class PlantPage extends StatelessWidget {
  final String plantName;

  PlantPage({this.plantName = 'faith', Key key}) : super(key: key);

  // Opens a dialog for when today's activity has already been completed
  void openActivityDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ExtraStudyDialog()
    ).then((bool doActivity) {
      if (doActivity ?? false)
        openActivity(context);
    });
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
    return HelpPage(
      'plant',
      title: 'Plants',
      helpText: 'Water your plants each day by clicking the blue button below.',
      child: PlantView(
        plantName,
        child: Scaffold(
          appBar: AppBar(
            title: Text('My Plant')
          ),

          drawer: PlantSelectDrawer(plantName),

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
                  child: PlantProgressIndicator(plantName),
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
                  onPressed: () => Navigator.pushNamed(context, '/journal', arguments: plantName),
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
      ),
    );
  }
}
