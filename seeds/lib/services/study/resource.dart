import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;

import '../../widgets/highlight/study_block.dart';
import '../utility.dart';

enum _MediaType { image, video }

class _MediaElement extends StudyElement {
  _MediaType type;
  String url;

  _MediaElement(this.type, this.url);

  @override
  String toString() => '{$type: $url}';

  @override
  Widget toWidget(BuildContext context, int index) {
    if (type == _MediaType.image) {
      return Image.network(url);
    } else {
      return Text('Video: $url');
    }
  }
}

class _TitleElement extends StudyElement {
  String text;

  _TitleElement(this.text);

  @override
  String toString() => '{Title: "$text"}';

  @override
  Widget toWidget(BuildContext context, int index) => Text(
        text,
        style: Theme.of(context)
            .textTheme
            .headline4
            .copyWith(fontFamily: 'Buenard'),
        textAlign: TextAlign.center,
      );
}

class _TextElement extends StudyElement {
  int verse;
  String text;

  _TextElement(this.text, {this.verse});

  @override
  String toString() =>
      verse == null ? '{Text: "$text"}' : '{Text: $verse. "$text"}';

  @override
  Widget toWidget(BuildContext context, int index) => HighlightStudyBlock(text,
      id: index, leadingText: verse == null ? null : '$verse. ');
}

abstract class StudyElement {
  Widget toWidget(BuildContext context, int index);

  StudyElement();

  factory StudyElement.fromXmlElement(xml.XmlElement element) {
    var tag = element.name.local;

    if (tag == 'image') {
      return _MediaElement(_MediaType.image, element.getAttribute('url'));
    } else if (tag == 'video') {
      return _MediaElement(_MediaType.video, element.getAttribute('url'));
    } else if (tag == 'title') {
      return _TitleElement(element.text);
    } else if (tag == 'highlight') {
      return _TextElement(element.text,
          verse: int.tryParse(element.getAttribute('verse') ?? ''));
    } else {
      return null;
    }
  }
}

enum Category {
  oldTestament,
  newTestament,
  bookOfMormon,
  doctrineAndCovenants,
  pearlOfGreatPrice,
  generalConference,
  other
}

class StudyResource {
  Category category;
  Set<String> topics;
  String reference;
  String referenceURL;

  List<StudyElement> body;

  StudyResource(
      this.category, this.topics, this.reference, this.referenceURL, this.body);

  StudyResource.fromXmlElement(xml.XmlElement element) {
    // Locate topics, reference, and body of study resource
    var topicElements = element.findElements('topic');
    var referenceElement = element.findElements('reference').first;
    Iterable<xml.XmlNode> bodyElements =
        element.findElements('body').first.children;

    // Initialize properties
    category = element.getAttribute('category').toEnum(Category.values) ??
        Category.other;
    topics = topicElements.map((t) => t.text).toSet();
    reference = referenceElement.text;
    referenceURL = referenceElement.getAttribute('url');

    // Initialize body
    body = <StudyElement>[];

    for (var node in bodyElements) {
      if (node is xml.XmlElement) {
        var element = StudyElement.fromXmlElement(node);

        if (element != null) body.add(element);
      }
    }
  }

  @override
  String toString() =>
      'StudyResource [$category] {$topics, $reference, $referenceURL}: $body';
}
