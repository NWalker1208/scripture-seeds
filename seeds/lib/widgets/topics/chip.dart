import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/data/progress.dart';
import '../../services/topics/index.dart';

class TopicChip extends StatelessWidget {
  final Topic topic;

  const TopicChip(this.topic, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ActionChip(
        elevation: 2,
        pressElevation: 4,
        label: Consumer<ProgressData>(
          builder: (context, progress, child) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (progress.recordNames.contains(topic.id)) ...const [
                Icon(Icons.check),
                SizedBox(width: 8)
              ],
              child,
            ],
          ),
          child: Text(topic.name),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/topics/details',
            arguments: topic.id,
          );
        },
      );
}
