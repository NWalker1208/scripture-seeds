import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../extensions/string.dart';
import '../services/data/progress.dart';
import '../services/data/wallet.dart';
import '../services/scriptures/volumes.dart';
import '../services/topics/index.dart';
import '../services/topics/provider.dart';
import '../services/topics/reference.dart';
import '../widgets/dashboard/indicators/wallet.dart';
import '../widgets/dialogs/purchase_topic.dart';
import '../widgets/help_info.dart';
import '../widgets/topics/list.dart';

class TopicDetailsPage extends StatelessWidget {
  final Topic topic;

  TopicDetailsPage(this.topic) : super(key: ValueKey(topic));

  @override
  Widget build(BuildContext context) => HelpInfo(
        'topic_details',
        title: 'Topics',
        helpText: 'Here you can read any scriptures associated with this '
            'topic.\n\nTo create a plant that will help you study this topic '
            'each day, press the button at the bottom of the screen.',
        child: Scaffold(
          appBar: AppBar(title: Text('Details')),
          body: Column(
            children: [
              ListTile(title: Text('Scriptures', textAlign: TextAlign.center)),
              Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: Volume.values.length,
                  itemBuilder: (context, index) =>
                      _VolumeRefList(Volume.values[index], topic.references),
                  separatorBuilder: (context, index) => Divider(),
                ),
              ),
              Divider(height: 1),
              ListTile(
                title: Text('Related Topics', textAlign: TextAlign.center),
              ),
              Divider(height: 1),
              Container(
                constraints: BoxConstraints(maxHeight: 165),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  shrinkWrap: true,
                  primary: false,
                  children: [
                    Consumer<TopicIndexProvider>(
                      builder: (context, indexProvider, child) => TopicList(
                          topics: indexProvider.index.relatedTo(topic.id)),
                    ),
                  ],
                ),
              ),
            ],
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
                  child: _PurchasePlantButton(topic),
                ),
              ],
            ),
          ),
        ),
      );
}

class _VolumeRefList extends StatelessWidget {
  final Volume volume;
  final Iterable<Reference> references;

  _VolumeRefList(this.volume, this.references, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var refsInVolume = references.where((ref) => ref.volume == volume);

    if (refsInVolume.isEmpty) {
      return ListTile(
        title: Text(volume.title),
        subtitle: Text('No scriptures found'),
      );
    }

    return Column(
      children: [
        ListTile(title: Text(volume.title)),
        for (var reference in refsInVolume)
          ListTile(
            title: Text(reference.toString()),
            onTap: () => Navigator.of(context)
                .pushNamed('/scripture', arguments: reference.toString()),
            dense: true,
          ),
      ],
    );
  }
}

class _PurchasePlantButton extends StatelessWidget {
  final Topic topic;

  _PurchasePlantButton(this.topic, {Key key}) : super(key: key);

  void _purchase(BuildContext context) {
    if (Provider.of<WalletData>(context, listen: false).canAfford(topic.cost)) {
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
  Widget build(BuildContext context) => Consumer<ProgressData>(
        builder: (context, progress, child) {
          var purchased = progress.recordNames.contains(topic.id);
          return IconTheme.merge(
            data: IconThemeData(color: Colors.white),
            child: ActionChip(
              elevation: 6,
              pressElevation: 12,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity(
                vertical: VisualDensity.maximumDensity,
              ),
              backgroundColor: Colors.green,
              labelStyle: DefaultTextStyle.of(context)
                  .style
                  .copyWith(color: Colors.white),
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
