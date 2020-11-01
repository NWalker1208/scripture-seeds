import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/library/study_resource.dart' as StudyResource;
import 'package:seeds/services/settings/library_filter.dart';
import 'package:seeds/services/utility.dart';

class LibraryFilterSettings extends StatelessWidget {
  const LibraryFilterSettings({
    Key key,
  }) : super(key: key);

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

        Consumer<LibraryFilter>(
          builder: (context, filter, child) => Column(
            children: StudyResource.Category.values.map(
              (category) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(addSpaces(category.toString())),
                  Switch(
                    value: filter[category],
                    onChanged: (value) => filter[category] = value
                  )
                ],
              )
            ).toList(),
          ),
        )
      ]
    );
  }
}
