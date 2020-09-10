import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/services/library/library_history.dart';
import 'package:seeds/services/library/web_cache.dart';
import 'package:xml/xml.dart' as XML;
import 'package:seeds/services/library/study_resource.dart';

class Library extends ChangeNotifier {
  Set<String> _topics;
  List<StudyResource> resources;

  bool get loaded => _topics != null && resources != null;
  List<String> get topics => (_topics?.toList() ?? [])..sort();

  Library(BuildContext context, {lang = 'en'}) {
    refresh(lang: lang);
  }

  Future<void> refresh({lang = 'en'}) async {
    File libFile = await LibraryWebCache.getLibraryFile(lang: lang);
    XML.XmlDocument xmlDoc = XML.parse(await libFile.readAsString());
    _loadResourcesFromXml(xmlDoc);
  }

  Future<void> refreshFromAssets(AssetBundle assets, {lang = 'en'}) async {
    XML.XmlDocument xmlDoc = await assets.loadStructuredData(
      'assets/library_$lang.xml',
      (text) async => XML.parse(text)
    );
    _loadResourcesFromXml(xmlDoc);
  }

  void _loadResourcesFromXml(XML.XmlDocument doc) {
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
          topics.map((t) => t.text).toSet(),
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