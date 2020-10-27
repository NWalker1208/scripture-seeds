import 'dart:core';
import 'package:seeds/services/library/history.dart';
import 'package:seeds/services/settings/library_filter.dart';
import 'package:xml/xml.dart';
import 'package:seeds/services/library/study_resource.dart';

class Library {
  static const int _kMaxSchema = 1;

  final int version;
  Map<String, int> topicPrices;
  List<StudyResource> resources;

  Set<String> get topics => topicPrices.keys.toSet();
  List<String> get topicsSorted => topicPrices.keys.toList()..sort();

  Library._({this.version = -1, this.topicPrices, this.resources});

  // Finds the least recent study resources for the given topic
  List<StudyResource> leastRecent(LibraryHistory history, {LibraryFilter filter, String topic}) {
    List<StudyResource> leastRecent = List<StudyResource>();
    DateTime leastRecentDate;

    resources.forEach((res) {
      if ((filter == null || filter[res.category]) &&
          (topic == null || res.topics.contains(topic))) {
        DateTime lastStudied = history.dateLastStudied(res);

        if (leastRecent.length == 0 ||
            lastStudied == null ||
            (leastRecentDate != null && lastStudied.isBefore(leastRecentDate))) {
          if (lastStudied != leastRecentDate) {
            leastRecentDate = lastStudied;
            leastRecent.clear();
          }

          leastRecent.add(res);
        }
      }
    });

    print('Found ${leastRecent.length} resources that were last studied ${leastRecentDate ?? 'never'}.');
    return leastRecent;
  }

  /// XML Functions
  static int schemaOfXml(XmlElement library) => int.parse(library?.getAttribute('schema') ?? '0');
  static int versionOfXml(XmlElement library) => int.parse(library?.getAttribute('version') ?? '0');

  static Library fromXmlElement(XmlElement library) {
    if (library == null)
      return null;

    int version;
    Map<String, int> topicPrices;
    List<StudyResource> resources;

    // Attempt to parse document. Return false if fails.
    try {
      // Check schema
      int schema = schemaOfXml(library);
      if (schema > _kMaxSchema) {
        print('XML library schema is too new ($schema > $_kMaxSchema)');
        return null;
      }

      // Load version
      version = versionOfXml(library);

      // Load topics
      Iterable<XmlElement> summaryNodes = library.findElements('summary');

      if (summaryNodes.isNotEmpty) {
        topicPrices = Map<String, int>.fromIterable(
          summaryNodes.first.findElements('topic'),

          key: (topicNode) =>
            (topicNode as XmlElement).innerText,
          value: (topicNode) =>
            int.parse((topicNode as XmlElement).getAttribute('price') ?? '1')
        );
      }

      // Load resources
      resources = library.findElements('resource').map((e) => StudyResource.fromXmlElement(e)).toList();
    } catch (e) {
      print('Unable to load library from XML document: $e');
      return null;
    }

    // If no topic summary was provided, update topics from resources
    if (topicPrices == null)
      topicPrices = _resourcesToTopics(resources);

    print('Library version $version parsed successfully.');
    return Library._(version: version, topicPrices: topicPrices, resources: resources);
  }

  static Map<String, int> _resourcesToTopics(List<StudyResource> resources) {
    Map<String, int> topicPrices = Map<String, int>();
    resources.forEach((res) =>
      res.topics.forEach((topic) =>
        topicPrices[topic] = 1
      )
    );
    return topicPrices;
  }
}
