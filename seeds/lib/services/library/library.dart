import 'dart:core';
import 'package:flutter/material.dart';
import 'package:seeds/services/library/history.dart';
import 'package:seeds/services/settings/library_filter.dart';
import 'package:xml/xml.dart';
import 'package:seeds/services/library/study_resource.dart';

class Library extends ChangeNotifier {
  static const int _kMaxSchema = 1;

  int _version = -1;
  Map<String, int> _topics;
  List<StudyResource> resources;

  bool get loaded => _topics != null && resources != null;
  Set<String> get topics => _topics?.keys?.toSet() ?? Set<String>();
  List<String> get topicsSorted => (_topics?.keys?.toList() ?? <String>[])..sort();

  Library([XmlElement xmlLibrary]) {
    if (xmlLibrary != null)
      loadFromXml(xmlLibrary);
  }

  static int schemaOfXml(XmlElement library) => int.parse(library?.getAttribute('schema') ?? '0');
  static int versionOfXml(XmlElement library) => int.parse(library?.getAttribute('version') ?? '0');

  bool loadFromXml(XmlElement library) {
    int newVersion;
    List<StudyResource> newResources;
    Map<String, int> newTopics;

    // Attempt to parse document. Return false if fails.
    try {
      // Check schema
      int schema = schemaOfXml(library);
      if (schema > _kMaxSchema) {
        print('XML library schema is too new ($schema > $_kMaxSchema)');
        return false;
      }

      // Check version
      newVersion = versionOfXml(library);
      if (newVersion < _version) {
        print('XML library is older than existing ($newVersion < $_version)');
        return false;
      }

      // Load topics
      Iterable<XmlElement> summaryNodes = library.findElements('summary');

      if (summaryNodes.isNotEmpty) {
        newTopics = Map<String, int>.fromIterable(
          summaryNodes.first.findElements('topic'),

          key: (topicNode) =>
            (topicNode as XmlElement).innerText,
          value: (topicNode) =>
            int.parse((topicNode as XmlElement).getAttribute('price') ?? '1')
        );
      }

      // Load resources
      newResources = library.findElements('resource').map((e) => StudyResource.fromXmlElement(e)).toList();
    } catch (e) {
      print('Unable to load library from XML document: $e');
      return false;
    }

    // Save parsed data
    _version = newVersion;
    resources = newResources;

    // If no topic summary was provided, update topics from resources
    if (newTopics == null)
      _updateTopics();
    else
      _topics = newTopics;

    print('Library version $newVersion loaded successfully!');
    notifyListeners();
    return true;
  }

  int priceOfTopic(String topic) => _topics[topic];

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

  void _updateTopics() {
    _topics = Map<String, int>();
    resources.forEach((res) =>
      res.topics.forEach((topic) =>
        _topics[topic] = 1
      )
    );
  }
}
