import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../history/provider.dart';
import '../scriptures/database.dart';
import '../scriptures/reference.dart';
import '../settings/filter.dart';
import '../topics/provider.dart';

class StudyLibraryProxy {
  StudyLibraryProxy({
    this.scriptures,
    this.topics,
    this.filter,
    this.history,
  });

  factory StudyLibraryProxy.fromContext(BuildContext context) =>
      StudyLibraryProxy(
        scriptures: Provider.of(context),
        topics: Provider.of(context),
        filter: Provider.of(context),
        history: Provider.of(context),
      );

  final ScriptureDatabase scriptures;
  final TopicIndexProvider topics;
  final FilterProvider filter;
  final HistoryProvider history;

  List<ScriptureReference> availableReferences(String topic) {
    var references = topics.index[topic].references.toList();
    references.removeWhere((ref) => !filter[ref.volume]);
    return references;
  }

  List<ScriptureReference> leastRecent(String topic) {
    var references = availableReferences(topic);
    var leastRecent = <ScriptureReference>[];
    DateTime leastRecentDate;

    for (var ref in references) {
      var lastStudied = history.lastStudied(ref);

      if (leastRecent.isEmpty ||
          lastStudied == null ||
          (leastRecentDate != null && lastStudied.isBefore(leastRecentDate))) {
        if (lastStudied != leastRecentDate) {
          leastRecentDate = lastStudied;
          leastRecent.clear();
        }

        leastRecent.add(ref);
      }
    }

    print('Found ${leastRecent.length} references that were last studied '
        '${leastRecentDate ?? 'never'}.');
    return leastRecent;
  }
}
