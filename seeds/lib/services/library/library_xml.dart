import 'dart:core';
import 'package:flutter/material.dart';
import 'package:seeds/services/library/library_history.dart';
import 'package:xml/xml.dart' as XML;
import 'package:seeds/services/library/study_resource.dart';

class Library extends ChangeNotifier {
  List<String> topics;
  List<StudyResource> resources;

  bool get loaded => topics != null && resources != null;

  Library(BuildContext context, {lang = 'en'}) {
    // Load library XML file
    DefaultAssetBundle.of(context).loadStructuredData(
      'assets/library_$lang.xml',
      (text) async => XML.parse(text)
    ).then((XML.XmlDocument xmlDoc) {
      // Process XML file after loading
      resources = _xmlToStudyResources(xmlDoc.findAllElements('resource'));
      _updateTopics();
      notifyListeners();

      // Print study resources for debug
      print('Processed resources: $resources');
    });
  }

  // Finds the least recent study resource for the given topic
  StudyResource leastRecent(LibraryHistory history, {String topic}) {
    StudyResource leastRecent;
    DateTime leastRecentDate;

    resources.forEach((res) {
      if (topic == null || res.topics.contains(topic)) {
        DateTime lastStudied = history.dateLastStudied(res);

        if (leastRecentDate == null || lastStudied.isBefore(leastRecentDate)) {
          leastRecent = res;
          leastRecentDate = lastStudied;
        }
      }
    });

    return leastRecent;
  }

  void _updateTopics() {
    topics = List<String>();

    resources.forEach((res) {
      res.topics.forEach((topic) {
        String lowercase = topic.toLowerCase();
        if (!topics.contains(lowercase))
          topics.add(lowercase);
      });
    });
  }

  static List<StudyResource> _xmlToStudyResources(Iterable<XML.XmlElement> xmlResources) {
    List<StudyResource> resources = List<StudyResource>();

    // Iterate over every resource tag
    xmlResources.forEach((resource) {
      // Locate topics, reference, and body of study resource
      Iterable<XML.XmlElement> topics = resource.findElements('topic');
      XML.XmlElement reference = resource.findElements('reference').first;
      Iterable<XML.XmlNode> bodyElements = resource.findElements('body').first.children;

      // Convert XmlElements to StudyResource
      resources.add(StudyResource(
          int.parse(resource.getAttribute('id')),
          topics.map((t) => t.text).toList(),
          reference.text,
          reference.getAttribute('url'),
          _xmlToStudyElements(bodyElements)
      ));
    });

    return resources;
  }

  static List<StudyElement> _xmlToStudyElements(Iterable<XML.XmlNode> xmlNodes) {
    List<StudyElement> elements = List<StudyElement>();

    xmlNodes.forEach((node) {
      if (node is XML.XmlElement) {
        StudyElement element = StudyElement.fromXmlElement(node);

        if (element != null)
          elements.add(element);
      }
    });

    return elements;
  }
}