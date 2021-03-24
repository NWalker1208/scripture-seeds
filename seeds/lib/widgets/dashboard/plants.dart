import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/progress/provider.dart';
import '../../services/topics/provider.dart';
import '../animation/appear_transition.dart';
import '../animation/list.dart';
import '../plant/button.dart';
import 'indicators/daily_progress.dart';

class PlantsDashboard extends StatelessWidget {
  const PlantsDashboard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Dashboard item title
          const ListTile(
            title: Text('Plants'),
            trailing: DailyProgressIndicator(),
          ),
          // Plant list
          SizedBox(
            height: 250,
            child: Consumer2<ProgressProvider, TopicIndexProvider>(
              builder: (context, progress, topics, child) {
                // Check if topics are done loading
                if (topics.index == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Remove records that don't have topics in the index
                var visible = topics.index.topics;
                var recordTopics = progress.topics
                    .where((t) => visible.contains(t))
                    .toList()
                      ..sort();

                return AnimatedListBuilder<String>(
                  items: recordTopics,
                  duration: const Duration(milliseconds: 200),
                  insertDelay: const Duration(milliseconds: 200),
                  removeDelay: const Duration(milliseconds: 400),
                  itemBuilder: (_, topic, animation) => AppearTransition(
                    visibility: animation,
                    axis: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 8.0),
                      child: AspectRatio(
                        aspectRatio: 3 / 5,
                        child: PlantButton(topic, key: ValueKey(topic)),
                      ),
                    ),
                  ),
                  viewBuilder: (_, itemCount, builder) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: itemCount > 0
                        ? ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: itemCount,
                            itemBuilder: builder,
                          )
                        : Center(child: Text('Select a topic below to begin.')),
                  ),
                );
              },
            ),
          ),
        ],
      );
}
