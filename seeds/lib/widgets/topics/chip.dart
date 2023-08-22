import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/progress/provider.dart';
import '../../services/topics/topic.dart';
import '../../utility/go.dart';

class TopicChip extends StatelessWidget {
  final Topic topic;

  const TopicChip(this.topic, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ActionChip(
        label: Consumer<ProgressProvider>(
          builder: (context, progress, child) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (progress.names.contains(topic.id)) ...const [
                Icon(Icons.check),
                SizedBox(width: 8)
              ],
              child,
            ],
          ),
          child: Text(topic.name),
        ),
        onPressed: () => Go.from(context).toDetails(topic.id),
      );
}
