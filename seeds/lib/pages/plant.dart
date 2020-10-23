import 'package:flutter/material.dart';
import 'package:seeds/services/custom_icons.dart';
import 'package:seeds/services/data/progress_record.dart';
import 'package:seeds/services/data/wallet.dart';
import 'package:seeds/widgets/dialogs/extra_study.dart';
import 'package:seeds/widgets/help_page.dart';
import 'package:seeds/widgets/plant/drawer.dart';
import 'package:seeds/widgets/plant/progress_indicator.dart';
import 'package:seeds/widgets/plant/view.dart';
import 'package:seeds/services/data/progress.dart';
import 'package:seeds/services/utility.dart';
import 'package:social_share/social_share.dart';
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

  void collectReward(BuildContext context) {
    ProgressData progress = Provider.of<ProgressData>(context, listen: false);
    int reward = progress.collectReward(plantName);
    Provider.of<WalletData>(context, listen: false).give(reward);

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('You collected $reward seeds.')
    ));
  }

  @override
  Widget build(BuildContext context) {
    return HelpPage(
      'plant',
      title: 'Plants',
      helpText: 'Water your plants each day by clicking the blue button below.',
      child: Scaffold(
        appBar: AppBar(
          title: Text(plantName.capitalize()),
          bottom: PreferredSize(
            preferredSize: Size(0, 50),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: PlantProgressIndicator(plantName, textColor: Colors.white),
            )
          ),
        ),

        drawer: PlantSelectDrawer(plantName),

        backgroundColor: Colors.transparent,
        body: PlantView(
          plantName,
          plantPadding: EdgeInsets.symmetric(vertical: 50)
        ),

        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.book),
                onPressed: () => Navigator.pushNamed(context, '/journal', arguments: plantName),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<ProgressData>(
                  builder: (context, progressData, child) {
                    ProgressRecord record = progressData.getProgressRecord(plantName);
                    bool reward = record.rewardAvailable;
                    bool canMakeProgress = record.canMakeProgressToday;

                    return FloatingActionButton(
                        child: Icon(reward ? CustomIcons.sickle : CustomIcons.water_drop),
                        backgroundColor: (canMakeProgress || reward) ? Theme.of(context).accentColor : Colors.grey[500],
                        onPressed: () {
                          if (reward)
                            collectReward(context);
                          else if (!canMakeProgress)
                            openActivityDialog(context);
                          else
                            openActivity(context);
                        }
                    );
                  },
                ),
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
