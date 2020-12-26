import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/custom_icons.dart';
import '../services/data/progress.dart';
import '../services/topics/provider.dart';
import 'animated_list.dart';

class TopicList extends StatelessWidget {
  final Set<String> topics;
  final int maxToShow;

  const TopicList({
    this.topics,
    this.maxToShow,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer2<TopicIndexProvider, ProgressData>(
        builder: (context, indexProvider, progress, child) {
          var index = indexProvider.index;

          // Check if library is still loading
          if (index == null) {
            return const Text('Loading...', textAlign: TextAlign.center);
          }

          var topicList = (topics ?? index.topics).toList();

          // Check if empty
          if (topicList.isEmpty) {
            return const Text(
              'No topics found',
              textAlign: TextAlign.center,
            );
          }

          // Reduce to maxToShow topics if specified
          if (maxToShow != null) topicList = topicList.take(maxToShow).toList();

          return AnimatedListBuilder<String>.list(
            items: topicList,
            duration: const Duration(milliseconds: 200),
            childBuilder: (context, topic, animation) => FadeTransition(
              opacity: animation,
              child: SizeTransition(
                axis: Axis.horizontal,
                sizeFactor: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: ActionChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      progress.recordNames.contains(topic)
                          ? const Icon(Icons.check)
                          : const Icon(CustomIcons.seeds),
                      const SizedBox(width: 8),
                      Text(index[topic].name),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/topics/details',
                      arguments: topic,
                    );
                  },
                ),
              ),
            ),
            viewBuilder: (context, children) => Wrap(
              spacing: 12.0,
              alignment: WrapAlignment.center,
              children: children,
            ),
          );
        },
      );
}
