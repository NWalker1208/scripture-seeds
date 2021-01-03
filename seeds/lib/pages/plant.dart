import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/widgets/app_bar_themed.dart';
import 'package:social_share/social_share.dart';

import '../extensions/string.dart';
import '../services/custom_icons.dart';
import '../services/data/progress.dart';
import '../services/data/wallet.dart';
import '../services/topics/index.dart';
import '../widgets/dialogs/extra_study.dart';
import '../widgets/dialogs/remove_plant.dart';
import '../widgets/help_info.dart';
import '../widgets/labeled_icon_button.dart';
import '../widgets/plant/progress_indicator.dart';
import '../widgets/plant/view.dart';

class PlantPage extends StatelessWidget {
  final Topic topic;

  PlantPage(this.topic, {Key key}) : super(key: key);

  void removePlant(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => RemovePlantDialog(topic),
    ).then((removed) {
      if (removed ?? false) {
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
        //Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) => HelpInfo(
        'plant',
        title: 'Plants',
        helpText: 'To help your plants grow, water them each day by studying '
            'the scriptures.\n\nClick the blue button below to study '
            'a scripture about ${topic.name}.',
        child: Scaffold(
          appBar: AppBar(
            title: Text(topic.name.capitalize()),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share',
                onPressed: () => SocialShare.shareOptions(
                  'I\'m studying about ${topic.name} with Scripture Seeds!',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Remove',
                onPressed: () => removePlant(context),
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size(0, 50),
              child: AppBarThemed(Padding(
                padding: const EdgeInsets.all(12.0),
                child: PlantProgressIndicator(topic.id),
              )),
            ),
          ),
          body: PlantView(
            topic.id,
            plantPadding: EdgeInsets.symmetric(vertical: 50),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                LabeledIconButton(
                  icon: const Icon(Icons.book),
                  label: 'Journal',
                  onPressed: () => Navigator.pushNamed(context, '/journal',
                      arguments: topic.name),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _StudyButton(topic),
                ),
                LabeledIconButton(
                  icon: const Icon(Icons.article),
                  label: 'Details',
                  onPressed: () => Navigator.pushNamed(
                      context, '/topics/details',
                      arguments: topic.id),
                ),
              ],
            ),
          ),
        ),
      );
}

class _StudyButton extends StatelessWidget {
  final Topic topic;

  const _StudyButton(this.topic, {Key key}) : super(key: key);

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
  Widget build(BuildContext context) => Consumer<ProgressData>(
        builder: (context, progressData, child) {
          var record = progressData.getProgressRecord(topic.id);
          var reward = record.rewardAvailable;
          var canMakeProgress = record.canMakeProgressToday;

          return FloatingActionButton(
            tooltip: 'Study',
            child: Icon(reward ? CustomIcons.sickle : CustomIcons.water_drop),
            backgroundColor: (canMakeProgress || reward)
                ? Theme.of(context).accentColor
                : Theme.of(context).disabledColor,
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
      );
}
