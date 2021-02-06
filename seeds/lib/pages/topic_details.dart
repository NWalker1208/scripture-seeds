import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../extensions/string.dart';
import '../services/progress/provider.dart';
import '../services/scriptures/reference.dart';
import '../services/scriptures/volumes.dart';
import '../services/topics/index.dart';
import '../services/topics/provider.dart';
import '../services/wallet/provider.dart';
import '../widgets/app_bar_themed.dart';
import '../widgets/dashboard/indicators/wallet.dart';
import '../widgets/dialogs/purchase_topic.dart';
import '../widgets/topics/list.dart';
import '../widgets/tutorial/focus.dart';
import '../widgets/tutorial/help_button.dart';
import '../widgets/tutorial/help_info.dart';

class TopicDetailsPage extends StatelessWidget {
  final Topic topic;

  TopicDetailsPage(this.topic) : super(key: ValueKey(topic));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Details'),
          actions: [HelpButton(() => context)],
        ),
        body: HelpInfo(
          title: 'Topics',
          helpText: 'Here you can read any scriptures associated with this '
              'topic.\n\nTo create a plant that will help you study this topic '
              'each day, press the button at the bottom of the screen.',
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      primary: false,
                      automaticallyImplyLeading: false,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
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
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      centerTitle: true,
                      title: Text('Related Topics',
                          style: Theme.of(context).textTheme.subtitle1),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      sliver: SliverToBoxAdapter(
                        child: Consumer<TopicIndexProvider>(
                          builder: (context, indexProvider, child) => TopicList(
                              topics: indexProvider.index.relatedTo(topic.id)),
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
                  tag: 'purchase_topic',
                  overlayLabel: Text('Press to plant seed.'),
                  child: _PurchasePlantButton(topic),
                ),
              ),
            ],
          ),
        ),
      );
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
                      onPressed: () => Navigator.of(context).pushNamed(
                          '/scripture',
                          arguments: reference.toString()),
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
        content: Text('You need to collect more seeds from other topics '
            'before starting this one.'),
      ));
    }
  }

  void _openPlant(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/plant', ModalRoute.withName('/'),
        arguments: topic.id);
  }

  @override
  Widget build(BuildContext context) => Consumer<ProgressProvider>(
        builder: (context, progress, child) {
          var purchased = progress.names.contains(topic.id);
          return AppBarThemed(
            ActionChip(
              elevation: 6,
              pressElevation: 12,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity:
                  VisualDensity(vertical: VisualDensity.maximumDensity),
              backgroundColor: Theme.of(context).primaryColor,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: purchased
                        ? const Icon(Icons.check)
                        : WalletIndicator(required: topic.cost),
                  ),
                  SizedBox(width: 8),
                  Text(purchased ? 'View Plant' : 'Plant Seed'),
                ],
              ),
              onPressed: purchased
                  ? () => _openPlant(context)
                  : () => _purchase(context),
            ),
          );
        },
      );
}
