import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/custom_icons.dart';
import '../services/data/progress.dart';
import '../services/data/wallet.dart';
import '../services/scriptures/volumes.dart';
import '../services/topics/index.dart';
import '../services/topics/provider.dart';
import '../services/topics/reference.dart';
import '../services/utility.dart';
import '../widgets/dashboard/indicators/wallet.dart';
import '../widgets/dialogs/purchase_topic.dart';
import '../widgets/help_info.dart';
import '../widgets/topic_list.dart';

class TopicDetailsPage extends StatelessWidget {
  final Topic topic;

  TopicDetailsPage(this.topic) : super(key: ValueKey(topic));

  @override
  Widget build(BuildContext context) => HelpInfo(
        'topic_details',
        title: 'Topics',
        helpText: 'Start a new plant for this topic by pressing '
            'the button at the bottom of the screen.',
        child: Scaffold(
          appBar: AppBar(
            title: Text(topic.name.capitalize()),
            actions: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: WalletIndicator(required: topic.cost),
              ),
            ],
          ),
          body: Column(
            children: [
              ListTile(
                  title: Text(
                'Scriptures',
                textAlign: TextAlign.center,
              )),
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
              Container(
                constraints: BoxConstraints(maxHeight: 160),
                child: ListView(shrinkWrap: true, children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Consumer<TopicIndexProvider>(
                      builder: (context, indexProvider, child) => TopicList(
                          topics: indexProvider.index.relatedTo(topic.id)),
                    ),
                  ),
                ]),
              )
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: _PurchasePlantTile(topic),
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

class _PurchasePlantTile extends StatelessWidget {
  final Topic topic;

  _PurchasePlantTile(this.topic, {Key key}) : super(key: key);

  void _purchase(BuildContext context) {
    if (Provider.of<WalletData>(context, listen: false).canAfford(topic.cost)) {
      showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (_) => PurchaseTopicDialog(topic)).then((purchased) {
        if (purchased ?? false) _openPlant(context);
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
          return ListTile(
            title: Text(
              purchased ? 'View plant' : 'Plant seed and begin studying',
            ),
            onTap: purchased
                ? () => _openPlant(context)
                : () => _purchase(context),
            leading: purchased
                ? const Icon(Icons.check)
                : const Icon(CustomIcons.seeds),
          );
        },
      );
}
