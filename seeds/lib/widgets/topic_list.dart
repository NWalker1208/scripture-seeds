import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/custom_icons.dart';
import '../services/data/progress.dart';
import '../services/topics/provider.dart';
import 'animated_list.dart';
import 'appear_transition.dart';

class TopicList extends StatelessWidget {
  final Set<String> topics;
  final bool showPurchased;
  final int maxToShow;

  const TopicList({
    this.topics,
    this.showPurchased = true,
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

          // Remove purchased topics if specified
          if (!showPurchased) {
            topicList
                .removeWhere((topic) => progress.recordNames.contains(topic));
          }

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
            values: topicList,
            duration: const Duration(milliseconds: 200),
            insertDelay: const Duration(milliseconds: 400),
            removeDelay: const Duration(milliseconds: 400),
            childBuilder: (context, topic, animation) => AppearTransition(
              visibility: animation,
              axis: Axis.horizontal,
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
            viewBuilder: (context, children) => Wrap(
              spacing: 12.0,
              alignment: WrapAlignment.center,
              children: children,
            ),
          );
        },
      );
}
