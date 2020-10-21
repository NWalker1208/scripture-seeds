import 'package:flutter/material.dart';
import 'package:seeds/widgets/highlight/study_block.dart';
import 'package:xml/xml.dart' as XML;

enum _MediaType {Image, Video}
class _MediaElement extends StudyElement {
  _MediaType type;
  String url;

  _MediaElement(this.type, this.url);

  @override
  String toString() => '{$type: $url}';

  @override
  Widget toWidget(BuildContext context, int index) {
    if (type == _MediaType.Image)
      return Image.network(url);
    /*FutureBuilder(
        future: DefaultCacheManager().getSingleFile(url),
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return Image.file(snapshot.data);
          else
            return CircularProgressIndicator();
        },
      );*/
    else
      return Text('Video: $url');
  }
}

class _TitleElement extends StudyElement {
  String text;

  _TitleElement(this.text);

  @override
  String toString() => '{Title: "$text"}';

  @override
  Widget toWidget(BuildContext context, int index) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline4.copyWith(fontFamily: 'Buenard'),
      textAlign: TextAlign.center,
    );
  }
}

class _TextElement extends StudyElement {
  int verse;
  String text;

  _TextElement(this.text, {this.verse});

  @override
  String toString() => verse == null ? '{Text: "$text"}' : '{Text: $verse. "$text"}';

  @override
  Widget toWidget(BuildContext context, int index) {
    return HighlightStudyBlock(
      text,
      id: index,
      leadingText: verse == null ? null : '$verse. '
    );
  }
}

abstract class StudyElement {
  Widget toWidget(BuildContext context, int index);

  StudyElement();

  factory StudyElement.fromXmlElement(XML.XmlElement element) {
    String tag = element.name.local;

    if (tag == 'image')
      return _MediaElement(_MediaType.Image, element.getAttribute('url'));
    else if (tag == 'video')
      return _MediaElement(_MediaType.Video, element.getAttribute('url'));
    else if (tag == 'title')
      return _TitleElement(element.text);
    else if (tag == 'highlight')
      // Use try parse to apply null as verse if element did not contain that attribute
      return _TextElement(element.text, verse: int.tryParse(element.getAttribute('verse') ?? ''));
    else
      return null;
  }
}

// Enum expressed as class
class Category {
  final String _value;

  const Category._(this._value);

  @override
  String toString() => _value;

  static Category parse(String value) {
    switch (value?.toLowerCase()) {
      case 'oldtestament':
        return OldTestament;
      case 'newtestament':
        return NewTestament;
      case 'bookofmormon':
        return BookOfMormon;
      case 'doctrineandcovenants':
        return DoctrineAndCovenants;
      case 'pearlofgreatprice':
        return PearlOfGreatPrice;
      case 'generalconference':
        return GeneralConference;
      case 'other':
        return Other;
      default:
        print('Failed to parse category $value');
        return null;
    }
  }

  // Enum values
  static const Category OldTestament = Category._('OldTestament');
  static const Category NewTestament = Category._('NewTestament');
  static const Category BookOfMormon = Category._('BookOfMormon');
  static const Category DoctrineAndCovenants = Category._('DoctrineAndCovenants');
  static const Category PearlOfGreatPrice = Category._('PearlOfGreatPrice');
  static const Category GeneralConference = Category._('GeneralConference');
  static const Category Other = Category._('Other');
}

class StudyResource {
  Category category;
  Set<String> topics;
  String reference;
  String referenceURL;

  List<StudyElement> body;

  StudyResource(this.category, this.topics, this.reference, this.referenceURL, this.body);

  StudyResource.fromXmlElement(XML.XmlElement element) {
    // Locate topics, reference, and body of study resource
    Iterable<XML.XmlElement> topicElements = element.findElements('topic');
    XML.XmlElement referenceElement = element.findElements('reference').first;
    Iterable<XML.XmlNode> bodyElements = element.findElements('body').first.children;

    // Initialize properties
    category = Category.parse(element.getAttribute('category')) ?? Category.Other;
    topics = topicElements.map((t) => t.text).toSet();
    reference = referenceElement.text;
    referenceURL = referenceElement.getAttribute('url');

    // Initialize body
    body = List<StudyElement>();

    bodyElements.forEach((node) {
      if (node is XML.XmlElement) {
        StudyElement element = StudyElement.fromXmlElement(node);

        if (element != null)
          body.add(element);
      }
    });
  }

  @override
  String toString() {
    return 'StudyResource [$category] {$topics, $reference, $referenceURL}: $body';
  }
}
