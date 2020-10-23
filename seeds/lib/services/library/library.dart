import 'dart:core';
import 'package:flutter/material.dart';
import 'package:seeds/services/library/history.dart';
import 'package:seeds/services/settings/library_filter.dart';
import 'package:xml/xml.dart';
import 'package:seeds/services/library/study_resource.dart';

class Library extends ChangeNotifier {
  Set<String> _topics;
  List<StudyResource> resources;

  bool get loaded => _topics != null && resources != null;
  Set<String> get topics => _topics?.toSet() ?? Set<String>();
  List<String> get topicsSorted => (_topics?.toList() ?? <String>[])..sort();

  Library([XmlDocument xmlDoc]) {
    if (xmlDoc != null)
      loadFromXml(xmlDoc);
  }

  bool loadFromXml(XmlDocument doc) {
    List<StudyResource> newResources;

    // Attempt to parse document. Return false if fails.
    try {
      newResources = doc.findAllElements('resource').map((e) => StudyResource.fromXmlElement(e)).toList();
    } catch (e) {
      print('Unable to load library from XML document: $e');
      return false;
    }

    resources = newResources;
    _updateTopics();

    print('Library loaded!');
    notifyListeners();
    return true;
  }

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
    _topics = Set<String>();
    resources.forEach((res) => _topics = _topics.union(res.topics));
  }
}
