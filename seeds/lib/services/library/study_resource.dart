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
  Widget toWidget(BuildContext context) {
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
  Widget toWidget(BuildContext context) {
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
  Widget toWidget(BuildContext context) {
    return HighlightStudyBlock(
      text,
      id: verse ?? 0,
      leadingText: verse == null ? null : '$verse. '
    );
  }
}

abstract class StudyElement {
  Widget toWidget(BuildContext context);

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

class StudyResource {
  int id;
  Set<String> topics;
  String reference;
  String referenceURL;

  List<StudyElement> body;

  StudyResource(this.id, this.topics, this.reference, this.referenceURL, this.body);

  @override
  String toString() {
    return 'StudyResource #$id {$topics, $reference, $referenceURL}: $body';
  }
}