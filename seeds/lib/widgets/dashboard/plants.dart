import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/library/library.dart';
import 'package:seeds/services/data/progress.dart';
import 'package:seeds/services/data/progress_record.dart';
import 'package:seeds/services/library/manager.dart';
import 'package:seeds/widgets/animated_list.dart';
import 'package:seeds/widgets/dashboard/indicators/daily_progress.dart';
import 'package:seeds/widgets/plant/button.dart';

class PlantsDashboard extends StatelessWidget {
  const PlantsDashboard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dashboard item title
        const ListTile(
          title: Text('Plants'),
          trailing: DailyProgressIndicator(),
        ),

        // Plant list
        SizedBox(
          height: 250,
          child: Consumer2<ProgressData, LibraryManager>(
            builder: (context, progress, libManager, child) {
              Library library = libManager.library;
              // Check if library is still loading
              if (library == null)
                return const Center(child: Text('Loading...'));

              // Sort records so that incomplete ones go first
              List<ProgressRecord> records =
                  progress.recordsWithTopics(library.topics)..sort();

              return Stack(children: [
                AnimatedListBuilder(
                  items: records,
                  duration: Duration(milliseconds: 250),
                  childBuilder: (context, record, animation) => FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      axis: Axis.horizontal,
                      sizeFactor: CurvedAnimation(
                          parent: animation, curve: Curves.easeOut),
                      child: AspectRatio(
                        aspectRatio: 3 / 5,
                        child: PlantButton(record.name),
                      ),
                    ),
                  ),
                  viewBuilder: (context, children) => ListView.separated(
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: children.length,
                    itemBuilder: (context, index) => children[index],
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                  ),
                ),

                // If no plants are started, show a message
                if (records.length == 0)
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
}
