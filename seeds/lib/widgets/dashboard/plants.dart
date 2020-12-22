import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/data/progress.dart';
import '../../services/data/progress_record.dart';
import '../../services/topics/provider.dart';
import '../animated_list.dart';
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
                  return const Center(child: Text('Loading...'));
                }

                // Sort records so that incomplete ones go first
                var records = progress.recordsWithTopics(topics.index.topics)
                  ..sort();

                return Stack(children: [
                  AnimatedListBuilder<ProgressRecord>(
                    items: records,
                    duration: const Duration(milliseconds: 200),
                    childBuilder: (context, record, animation) =>
                        FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        axis: Axis.horizontal,
                        sizeFactor: CurvedAnimation(
                            parent: animation, curve: Curves.ease),
                        child: AspectRatio(
                          aspectRatio: 3 / 5,
                          child: PlantButton(record.id),
                        ),
                      ),
                    ),
                    viewBuilder: (context, builder, itemCount) =>
                        ListView.separated(
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: builder,
                      itemCount: itemCount,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                    ),
                  ),

                  // If no plants are started, show a message
                  if (records.isEmpty)
                    const Center(
                      child: Text('Select a topic below to begin.'),
                    ),
                ]);
              },
            ),
          ),
        ],
      );
}
