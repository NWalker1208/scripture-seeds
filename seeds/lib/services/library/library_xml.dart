import 'dart:core';
import 'package:flutter/material.dart';
import 'package:seeds/services/library/library_history.dart';
import 'package:xml/xml.dart';
import 'package:seeds/services/library/study_resource.dart';

class Library extends ChangeNotifier {
  Set<String> _topics;
  List<StudyResource> resources;

  bool get loaded => _topics != null && resources != null;
  List<String> get topics => (_topics?.toList() ?? [])..sort();

  Library([XmlDocument xmlDoc]) {
    if (xmlDoc != null)
      loadFromXml(xmlDoc);
  }

  void loadFromXml(XmlDocument doc) {
    resources = _xmlToStudyResources(doc.findAllElements('resource'));
    _updateTopics();

    print('Library loaded!');
    notifyListeners();
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

    print('Resource #${leastRecent.id} was least recent for topic $topic.');

    return leastRecent;
  }

  void _updateTopics() {
    _topics = Set<String>();
    resources.forEach((res) => _topics = _topics.union(res.topics));
  }

  static List<StudyResource> _xmlToStudyResources(Iterable<XmlElement> xmlResources) {
    List<StudyResource> resources = List<StudyResource>();

    // Iterate over every resource tag
    xmlResources.forEach((resource) {
      // Locate topics, reference, and body of study resource
      Iterable<XmlElement> topics = resource.findElements('topic');
      XmlElement reference = resource.findElements('reference').first;
      Iterable<XmlNode> bodyElements = resource.findElements('body').first.children;

      // Convert XmlElements to StudyResource
      resources.add(StudyResource(
        int.parse(resource.getAttribute('id')),
        topics.map((t) => t.text).toSet(),
        reference.text,
        reference.getAttribute('url'),
        _xmlToStudyElements(bodyElements)
      ));
    });

    return resources;
  }

  static List<StudyElement> _xmlToStudyElements(Iterable<XmlNode> xmlNodes) {
    List<StudyElement> elements = List<StudyElement>();

    xmlNodes.forEach((node) {
      if (node is XmlElement) {
        StudyElement element = StudyElement.fromXmlElement(node);

        if (element != null)
          elements.add(element);
      }
    });

    return elements;
  }
}