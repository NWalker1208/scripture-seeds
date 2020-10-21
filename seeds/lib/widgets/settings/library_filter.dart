import 'package:flutter/material.dart';
import 'package:seeds/services/library/study_resource.dart' as StudyResource;
import 'package:seeds/services/utility.dart';

class LibraryFilterSettings extends StatelessWidget {
  String addSpaces(String str) {
    String newStr = str[0];

    for (int i = 1; i < str.length; i++)
      newStr += (str[i].isCapital ? ' ' : '') + str[i];

    return newStr;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Study Sources', style: Theme.of(context).textTheme.subtitle1),
      ] + StudyResource.Category.Values.map(
        (category) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(addSpaces(category.toString())),
            Switch(
              value: true,
            )
          ],
        )
      ).toList()
    );
  }
}
