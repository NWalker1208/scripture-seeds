import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as XML;

enum _MediaType {Image, Video}
class _MediaElement extends StudyElement {
  _MediaType type;
  String url;

  _MediaElement(this.type, this.url);

  @override
  String toString() => '{$type: $url}';

  @override
  Widget toWidget(BuildContext context) {
    return Text(url);
  }
}

class _TitleElement extends StudyElement {
  String text;

  _TitleElement(this.text);

  @override
  String toString() => '{Title: "$text"}';

  @override
  Widget toWidget(BuildContext context) {
    return Text(text);
  }
}

class _TextElement extends StudyElement {
  int verse;
  String text;

  _TextElement(this.text, {this.verse});

  @override
  String toString() => verse == null ? '{Text: "$text"}' : '{Text: $verse. "$text"}';

  @override
  Widget toWidget(BuildContext context) {
    return Text(text);
  }
}

abstract class StudyElement {
  Widget toWidget(BuildContext context);

  static StudyElement fromXmlElement(XML.XmlElement element) {
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

class StudyResource {
  int id;
  List<String> topics;
  String reference;
  String referenceURL;

  List<StudyElement> _body;

  StudyResource(this.id, this.topics, this.reference, this.referenceURL, this._body);

  @override
  String toString() {
    return 'StudyResource #$id {$topics, $reference, $referenceURL}: $_body';
  }
}