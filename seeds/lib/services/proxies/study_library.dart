import '../history/provider.dart';
import '../scriptures/provider.dart';
import '../scriptures/reference.dart';
import '../settings/study_filter.dart';
import '../topics/provider.dart';

class StudyLibraryProxy {
  StudyLibraryProxy({
    this.scriptures,
    this.topics,
    this.filter,
    this.history,
  });

  final ScriptureProvider scriptures;
  final TopicIndexProvider topics;
  final StudyFilter filter;
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
