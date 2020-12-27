import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/data/progress.dart';
import '../../services/data/progress_record.dart';
import '../../services/topics/provider.dart';
import '../animated_list.dart';
import '../appear_transition.dart';
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
            child: Consumer2<ProgressData, TopicIndexProvider>(
              builder: (context, progress, topics, child) {
                // Check if topics are done loading
                if (topics.index == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Sort records so that incomplete ones go first
                var records = progress.recordsWithTopics(topics.index.topics)
                  ..sort();

                return AnimatedListBuilder<ProgressRecord>(
                  values: records,
                  duration: const Duration(milliseconds: 200),
                  insertDelay: const Duration(milliseconds: 200),
                  removeDelay: const Duration(milliseconds: 400),
                  childBuilder: (_, record, animation) => AppearTransition(
                    visibility: animation,
                    axis: Axis.horizontal,
                    child: AspectRatio(
                      aspectRatio: 3 / 5,
                      child: PlantButton(
                        record.id,
                        key: ValueKey(record.id),
                      ),
                    ),
                  ),
                  viewBuilder: (_, builder, itemCount) => itemCount > 0
                      ? ListView.separated(
                          padding: EdgeInsets.all(8),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: builder,
                          itemCount: itemCount,
                          separatorBuilder: (_, index) =>
                              const SizedBox(width: 8),
                        )
                      : Center(child: Text('Select a topic below to begin.')),
                );
              },
            ),
          ),
        ],
      );
}
