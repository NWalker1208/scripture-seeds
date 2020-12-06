import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/library/library.dart';
import 'package:seeds/services/library/manager.dart';
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
    return Consumer2<LibraryManager, LibraryFilter>(
      builder: (context, libManager, filter, child) {
        List<StudyResource.Category> categories = StudyResource.Category.values.toList();
        categories.removeWhere((category) =>
          !libManager.library.resources.any((resource) => resource.category == category)
        );

        return Column(
          children: [
            const ListTile(title: Text('Study Sources', textAlign: TextAlign.center,)),
            ...categories.map(
              (category) => SwitchListTile(
                title: Text(addSpaces(category.toString())),
                value: filter[category],
                onChanged: (value) => filter[category] = value,
              ),
            ),
          ],
        );
      }
    );
  }
}
