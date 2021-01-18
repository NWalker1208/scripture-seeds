import '../history/provider.dart';
import '../scriptures/database.dart';
import '../settings/study_filter.dart';
import '../topics/provider.dart';
import '../topics/reference.dart';

class StudyLibraryProvider {
  final ScriptureDatabase scriptures;
  final TopicIndexProvider topics;
  final StudyFilter filter;
  final StudyHistory history;

  StudyLibraryProvider({
    this.scriptures,
    this.topics,
    this.filter,
    this.history,
  });

  Future<List<String>> getChapterOfReference(Reference reference) =>
      scriptures.getChapterText(reference.book, reference.chapter);

  List<Reference> availableReferences(String topic) {
    var references = topics.index[topic].references.toList();
    references.removeWhere((ref) => !filter[ref.volume]);
    return references;
  }

  List<Reference> leastRecent(String topic) {
    var references = availableReferences(topic);
    var leastRecent = <Reference>[];
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
