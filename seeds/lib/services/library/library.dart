import 'dart:core';
import 'package:flutter/material.dart';
import 'package:seeds/services/library/history.dart';
import 'package:seeds/services/settings/library_filter.dart';
import 'package:xml/xml.dart';
import 'package:seeds/services/library/study_resource.dart';

class Library extends ChangeNotifier {
  Map<String, int> _topics;
  List<StudyResource> resources;

  bool get loaded => _topics != null && resources != null;
  Set<String> get topics => _topics?.keys?.toSet() ?? Set<String>();
  List<String> get topicsSorted => (_topics?.keys?.toList() ?? <String>[])..sort();

  Library([XmlDocument xmlDoc]) {
    if (xmlDoc != null)
      loadFromXml(xmlDoc);
  }

  bool loadFromXml(XmlDocument doc) {
    List<StudyResource> newResources;
    Map<String, int> newTopics;

    // Attempt to parse document. Return false if fails.
    try {
      XmlElement libraryNode = doc.findElements('library').first;

      // Load topics
      Iterable<XmlElement> summaryNodes = libraryNode.findElements('summary');

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
      newResources = libraryNode.findElements('resource').map((e) => StudyResource.fromXmlElement(e)).toList();
    } catch (e) {
      print('Unable to load library from XML document: $e');
      return false;
    }

    resources = newResources;

    if (newTopics == null)
      _updateTopics();
    else
      _topics = newTopics;

    print('Library loaded!');
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
