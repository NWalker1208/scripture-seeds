import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';

import '../services/custom_icons.dart';
import '../services/data/progress.dart';
import '../services/data/wallet.dart';
import '../services/topics/index.dart';
import '../services/utility.dart';
import '../widgets/dialogs/extra_study.dart';
import '../widgets/help_page.dart';
import '../widgets/plant/progress_indicator.dart';
import '../widgets/plant/view.dart';

class PlantPage extends StatelessWidget {
  final Topic topic;

  PlantPage(this.topic, {Key key}) : super(key: key);

  // Opens a dialog for when today's activity has already been completed
  void openActivityDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const ExtraStudyDialog(),
    ).then((doActivity) {
      if (doActivity ?? false) openActivity(context);
    });
  }

  void openActivity(BuildContext context) {
    Navigator.pushNamed(context, '/plant/activity', arguments: topic.id);
  }

  void collectReward(BuildContext context) {
    var progress = Provider.of<ProgressData>(context, listen: false);
    var reward = progress.collectReward(topic.id);
    Provider.of<WalletData>(context, listen: false).give(reward);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('You collected $reward seeds.')));
  }

  @override
  Widget build(BuildContext context) => HelpPage(
        'plant',
        title: 'Plants',
        helpText:
            'Water your plants each day by clicking the blue button below.',
        child: Scaffold(
          appBar: AppBar(
            title: Text(topic.name.capitalize()),
            bottom: PreferredSize(
              preferredSize: const Size(0, 50),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: PlantProgressIndicator(
                  topic.id,
                  textColor: Colors.white,
                ),
              ),
            ),
          ),
          //drawer: PlantSelectDrawer(plantName),
          backgroundColor: Colors.transparent,
          body: PlantView(
            topic.id,
            plantPadding: EdgeInsets.symmetric(vertical: 50),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.book),
                  onPressed: () => Navigator.pushNamed(context, '/journal',
                      arguments: topic.name),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<ProgressData>(
                    builder: (context, progressData, child) {
                      var record = progressData.getProgressRecord(topic.id);
                      var reward = record.rewardAvailable;
                      var canMakeProgress = record.canMakeProgressToday;

                      return FloatingActionButton(
                        child: Icon(reward
                            ? CustomIcons.sickle
                            : CustomIcons.water_drop),
                        backgroundColor: (canMakeProgress || reward)
                            ? Theme.of(context).accentColor
                            : Colors.grey[500],
                        onPressed: () {
                          if (reward) {
                            collectReward(context);
                          } else if (!canMakeProgress) {
                            openActivityDialog(context);
                          } else {
                            openActivity(context);
                          }
                        },
                      );
                    },
                  ),
                ),
                Consumer<ProgressData>(builder: (context, progressData, child) {
                  var record = progressData.getProgressRecord(topic.id);
                  return IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => SocialShare.shareOptions(
                      'Day ${record.progress} of '
                      '${record.maxProgress} on ${topic.name}!',
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      );
}
