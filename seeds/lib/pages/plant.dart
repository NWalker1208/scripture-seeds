import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';

import '../extensions/string.dart';
import '../services/progress/provider.dart';
import '../services/topics/topic.dart';
import '../services/tutorial/provider.dart';
import '../services/wallet/provider.dart';
import '../utility/custom_icons.dart';
import '../utility/go.dart';
import '../widgets/app_bar_themed.dart';
import '../widgets/dialogs/extra_study.dart';
import '../widgets/dialogs/remove_plant.dart';
import '../widgets/labeled_icon_button.dart';
import '../widgets/plant/progress_indicator.dart';
import '../widgets/plant/view.dart';
import '../widgets/tutorial/button.dart';
import '../widgets/tutorial/focus.dart';
import '../widgets/tutorial/help.dart';

class PlantPage extends StatelessWidget {
  final Topic topic;

  PlantPage(this.topic, {Key key}) : super(key: key);

  void removePlant(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => RemovePlantDialog(topic),
    ).then((removed) {
      if (removed ?? false) Go.from(context).toHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TutorialProvider>(context).maybeShow(context, 'plant');
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.name.capitalize()),
        actions: [
          TutorialButton(),
          PopupMenuButton<Function()>(
            onSelected: (action) => action(),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Share'),
                value: () => SocialShare.shareOptions(
                  'I\'m studying about ${topic.name} with Scripture Seeds!',
                ),
              ),
              PopupMenuItem(
                child: Text('Remove'),
                value: () => removePlant(context),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(0, 50),
          child: AppBarThemed(Padding(
            padding: const EdgeInsets.all(12.0),
            child: TutorialFocus(
              'grow_plant',
              index: 0,
              overlayLabel: Text('When your plant is fully grown, you can '
                  'harvest it for more seeds.'),
              child: PlantProgressIndicator(topic.id),
            ),
          )),
        ),
      ),
      body: TutorialHelp(
        'plant',
        index: 0,
        title: 'Plants',
        helpText: 'To keep your plants healthy, you have to water them by '
            'studying a scripture for their topic.',
        child: TutorialHelp(
          'grow_plant',
          index: 1,
          title: 'Remember',
          helpText: 'If you forget to water your plant for too long, it will '
              'start to wilt and you will lose progress.\n\nRemember to '
              'study every day so that you can collect your reward.',
          child: PlantView(
            topic.id,
            padding: EdgeInsets.symmetric(vertical: 50),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TutorialFocus(
              'grow_plant',
              index: 2,
              overlayLabel: Text('Finally, tap here to view your journal.'),
              child: LabeledIconButton(
                icon: const Icon(Icons.book),
                label: 'Journal',
                onPressed: () => Go.from(context).toJournal(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TutorialFocus(
                'plant',
                index: 1,
                overlayLabel: Text('Tap here to water your plant.'),
                overlayShape: const CircleBorder(),
                child: _StudyButton(topic),
              ),
            ),
            LabeledIconButton(
              icon: const Icon(Icons.article),
              label: 'Details',
              onPressed: () => Go.from(context).toDetails(),
            ),
          ],
        ),
      ),
    );
  }
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

  void openActivity(BuildContext context) => Go.from(context).toActivity();

  void collectReward(BuildContext context) {
    var progress = Provider.of<ProgressProvider>(context, listen: false);
    var reward = progress.collectReward(topic.id);
    Provider.of<WalletProvider>(context, listen: false).add(reward);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('You collected $reward seeds.')));
  }

  @override
  Widget build(BuildContext context) => Consumer<ProgressProvider>(
        builder: (context, progressData, child) {
          var record = progressData.getRecord(topic.id);
          var reward = record.rewardAvailable;
          var canMakeProgress = record.canMakeProgressToday;

          if (!canMakeProgress) {
            Provider.of<TutorialProvider>(context)
                .maybeShow(context, 'grow_plant');
          }

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
