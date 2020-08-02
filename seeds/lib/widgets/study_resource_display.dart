import 'package:flutter/material.dart';
import 'package:seeds/services/library/study_resource.dart';

class StudyResourceDisplay extends StatelessWidget {
  final StudyResource resource;

  StudyResourceDisplay(this.resource, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: List<Widget>.generate(
          resource.body.length * 2 - 1,
          (index) => (index % 2 == 1) ? SizedBox(height: 8.0,) :
            resource.body[index ~/ 2].toWidget(context)
        )
      ),
    );
  }
}
