import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/progress/provider.dart';
import '../../services/topics/provider.dart';
import '../animation/appear_transition.dart';
import '../animation/list.dart';
import 'chip.dart';

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
  Widget build(BuildContext context) => Consumer<TopicIndexProvider>(
        builder: (context, indexProvider, child) {
          var index = indexProvider.index;

          // Check if library is still loading
          if (index == null) {
            return const Center(child: CircularProgressIndicator());
          }

          var topicList = (topics ?? index.topics).toList();

          // Remove purchased topics if specified
          if (!showPurchased) {
            var progress = Provider.of<ProgressProvider>(context);
            if (!progress.isLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            var purchased = progress.recordNames;
            topicList.removeWhere((topic) => purchased.contains(topic));
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: TopicChip(indexProvider.index[topic]),
              ),
            ),
            viewBuilder: (context, children) => Wrap(
              alignment: WrapAlignment.center,
              children: children,
            ),
          );
        },
      );
}
