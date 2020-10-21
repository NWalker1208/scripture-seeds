import 'dart:core';
import 'package:flutter/material.dart';
import 'package:seeds/services/library/library_history.dart';
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

  // Finds the least recent study resource for the given topic
  StudyResource leastRecent(LibraryHistory history, {String topic}) {
    StudyResource leastRecent;
    DateTime leastRecentDate;

    resources.forEach((res) {
      if (topic == null || res.topics.contains(topic)) {
        DateTime lastStudied = history.dateLastStudied(res);

        if (leastRecent == null || // No resource has been found yet, OR
            (lastStudied == null && leastRecentDate != null) || // Current resource has never been studied but the current least recent has, OR
            (lastStudied != null && leastRecentDate != null && lastStudied.isBefore(leastRecentDate))) { // Current resource was last studied before least recent resource.
          leastRecent = res;
          leastRecentDate = lastStudied;
        }
      }
    });

    print('${leastRecent.reference} was least recent for topic $topic.');

    return leastRecent;
  }

  void _updateTopics() {
    _topics = Set<String>();
    resources.forEach((res) => _topics = _topics.union(res.topics));
  }
}
