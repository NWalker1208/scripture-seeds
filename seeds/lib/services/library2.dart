import 'dart:core';
import 'package:xml/xml.dart' as XML;
import 'package:flutter/material.dart';

enum _ElementType {
  Image, Video, Title, Text, HighlightText
}

class _Element {
  _ElementType type;
  String content;

  _Element(this.content, {this.type = _ElementType.Text});

  @override
  String toString() {
    return '{$type, content: $content}';
  }
}

class StudyResource {
  int id;
  List<String> topics;
  String reference;
  String referenceURL;

  List<_Element> _body;

  StudyResource(this.id, this.topics, this.reference, this.referenceURL, this._body);

  @override
  String toString() {
    return 'StudyResource #$id {$topics, $reference, $referenceURL}: $_body';
  }
}

class Library {
  List<String> topics;
  List<StudyResource> resources;

  Library(BuildContext context, {lang = 'en'}) {
    DefaultAssetBundle.of(context).loadStructuredData('assets/library_$lang.xml', (text) async => XML.parse(text))
        .then((XML.XmlDocument xmlDoc) {
          topics = List<String>();
          resources = List<StudyResource>();

          xmlDoc.findAllElements('resource').forEach((resource) {
            print('Parsing resource: ${resource.toString()}');

            resources.add(StudyResource(
              int.parse(resource.getAttribute('id')),
              resource.findElements('topic').map((t) => t.text).toList(),
              resource.findElements('reference').first.text,
              resource.findElements('reference').first.getAttribute('url'),
              resource.findElements('body').first.children.map(
                (element) {
                  // TODO: Break this out into a separate system to skip irrelevant elements
                  if (element is XML.XmlText)
                    return _Element(element.text);
                  else if (element is XML.XmlElement)
                    switch (element.name.local) {
                      case 'image':
                        return _Element(element.getAttribute('url'), type: _ElementType.Image);
                      case 'video':
                        return _Element(element.getAttribute('url'), type: _ElementType.Video);
                      case 'title':
                        return _Element(element.text, type: _ElementType.Title);
                      case 'highlight':
                        return _Element(element.text, type: _ElementType.HighlightText);
                      default:
                        return null;
                    }
                  else
                    return null;
                }
              ).toList()
            ));
          });

          print(resources);
        });
  }
}