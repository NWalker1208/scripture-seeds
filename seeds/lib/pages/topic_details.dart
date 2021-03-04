import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../extensions/string.dart';
import '../services/progress/provider.dart';
import '../services/scriptures/reference.dart';
import '../services/scriptures/volumes.dart';
import '../services/topics/provider.dart';
import '../services/topics/topic.dart';
import '../services/tutorial/provider.dart';
import '../services/wallet/provider.dart';
import '../utility/go.dart';
import '../widgets/animation/switcher.dart';
import '../widgets/app_bar_themed.dart';
import '../widgets/dashboard/indicators/wallet.dart';
import '../widgets/dialogs/purchase_topic.dart';
import '../widgets/topics/list.dart';
import '../widgets/tutorial/button.dart';
import '../widgets/tutorial/focus.dart';
import '../widgets/tutorial/help.dart';

class TopicDetailsPage extends StatelessWidget {
  final Topic topic;

  TopicDetailsPage(this.topic) : super(key: ValueKey(topic));

  @override
  Widget build(BuildContext context) {
    Provider.of<TutorialProvider>(context).maybeShow(context, 'topic_details');
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        actions: [TutorialButton()],
      ),
      body: TutorialHelp(
        'topic_details',
        index: 0,
        title: 'Topics',
        helpText: 'You can view all the scriptures for any topic, but to help '
            'you remember to study it every day, you need to plant a seed.',
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    primary: false,
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    centerTitle: true,
                    title: Text('Scriptures',
                        style: Theme.of(context).textTheme.subtitle1),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      for (var volume in Volume.values)
                        _VolumeRefList(volume, topic.references),
                    ]),
                  ),
                ],
              ),
            ),
            Divider(height: DividerTheme.of(context).thickness),
            Container(
              constraints: BoxConstraints(maxHeight: 175),
              child: CustomScrollView(
                shrinkWrap: true,
                primary: false,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    primary: false,
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    centerTitle: true,
                    title: Text('Related Topics',
                        style: Theme.of(context).textTheme.subtitle1),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    sliver: SliverToBoxAdapter(
                      child: Consumer<TopicIndexProvider>(
                        builder: (context, indexProvider, child) => TopicList(
                            topics: indexProvider.index
                                .relatedTo(topic.id, maxCount: 8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            ListTile(
              title: Text(topic.name.capitalize()),
              subtitle: Text('Topic'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TutorialFocus(
                'topic_details',
                index: 1,
                overlayLabel: Text('Tap here to plant a seed for this topic.'),
                overlayShape: const StadiumBorder(),
                child: _PurchasePlantButton(topic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VolumeRefList extends StatelessWidget {
  final Volume volume;
  final Iterable<ScriptureReference> references;

  _VolumeRefList(this.volume, this.references, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var refsInVolume = references.where((ref) => ref.volume == volume);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
          child: Text(volume.title, style: Theme.of(context).textTheme.caption),
        ),
        if (refsInVolume.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('No scriptures found'),
          )
        else
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Wrap(
              alignment: WrapAlignment.start,
              children: [
                for (var reference in refsInVolume)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: ActionChip(
                      elevation: 4,
                      label: Text(reference.toString()),
                      onPressed: () => Go.from(context).toScripture(reference),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _PurchasePlantButton extends StatelessWidget {
  final Topic topic;

  _PurchasePlantButton(this.topic, {Key key}) : super(key: key);

  void _purchase(BuildContext context) {
    if (Provider.of<WalletProvider>(context, listen: false)
        .canAfford(topic.cost)) {
      showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (_) => PurchaseTopicDialog(topic)).then((purchased) {
        if (purchased ?? false) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Seed planted!'),
          ));
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You don\'t have enough seeds.'),
      ));
    }
  }

  void _openPlant(BuildContext context) => Go.from(context).toPlant();

  @override
  Widget build(BuildContext context) => Consumer<ProgressProvider>(
        builder: (context, progress, child) {
          final purchased = progress.names.contains(topic.id);
          if (purchased) {
            Provider.of<TutorialProvider>(context)
                .maybeShow(context, 'topic_plant');
          }
          return AppBarThemed(
            TutorialFocus(
              'topic_plant',
              overlayLabel: Text('Now tap again to view your plant.'),
              overlayShape: const StadiumBorder(),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(StadiumBorder()),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: purchased
                    ? () => _openPlant(context)
                    : () => _purchase(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSizeSwitcher(
                      child: purchased
                          ? const Icon(Icons.check)
                          : WalletIndicator(required: topic.cost),
                    ),
                    SizedBox(width: 8),
                    Text(purchased ? 'View Plant' : 'Plant Seed'),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
