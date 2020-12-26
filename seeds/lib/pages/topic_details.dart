import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/custom_icons.dart';
import '../services/data/progress.dart';
import '../services/data/progress_record.dart';
import '../services/data/wallet.dart';
import '../services/scriptures/volumes.dart';
import '../services/topics/index.dart';
import '../services/topics/provider.dart';
import '../services/topics/reference.dart';
import '../services/utility.dart';
import '../widgets/topic_list.dart';

class TopicDetailsPage extends StatelessWidget {
  final Topic topic;

  TopicDetailsPage(this.topic, {Key key}) : super(key: key);

  void _purchase(BuildContext context) {
    if (Provider.of<WalletData>(context, listen: false).spend(topic.cost)) {
      Provider.of<ProgressData>(context, listen: false)
          .createProgressRecord(ProgressRecord(topic.id));
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
    } else {
      print('Not enough funds to purchase "$topic"');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Collect more seeds to buy more topics.'),
      ));
    }
  }

  void _sell(BuildContext context) {
    if (Provider.of<ProgressData>(context, listen: false)
        .removeProgressRecord(topic.id)) {
      Provider.of<WalletData>(context, listen: false).give(topic.cost);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sold plant for ${topic.cost} seeds.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(topic.name.capitalize()),
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<ProgressData>(
              builder: (context, progress, child) {
                var purchased = progress.recordNames.contains(topic.id);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: ListTile(
                            title: Text(purchased
                                ? 'Purchased'
                                : 'Cost - ${topic.cost}'))),
                    FloatingActionButton(
                      child: Icon(CustomIcons.seeds),
                      onPressed: () =>
                          purchased ? _sell(context) : _purchase(context),
                      tooltip: purchased ? 'Sell' : 'Buy',
                    ),
                  ],
                );
              },
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
