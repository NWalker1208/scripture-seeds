import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/library/manager.dart';
import '../../services/library/study_resource.dart' as study_resource;
import '../../services/settings/library_filter.dart';
import '../../services/utility.dart';

class LibraryFilterSettings extends StatelessWidget {
  const LibraryFilterSettings({
    Key key,
  }) : super(key: key);

  String addSpaces(String str) {
    var newStr = str[0];

    for (var i = 1; i < str.length; i++) {
      newStr += (str[i].isCapital ? ' ' : '') + str[i];
    }

    return newStr;
  }

  @override
  Widget build(BuildContext context) =>
      Consumer2<LibraryManager, LibraryFilter>(
        builder: (context, libManager, filter, child) {
          var categories = study_resource.Category.values.toList();
          categories.removeWhere(
            (category) => !libManager.library.resources
                .any((resource) => resource.category == category),
          );

          return Column(
            children: [
              const ListTile(
                title: Text('Study Sources', textAlign: TextAlign.center),
              ),
              ...categories.map(
                (category) => SwitchListTile(
                  title: Text(addSpaces(category.toString())),
                  value: filter[category],
                  onChanged: (value) => filter[category] = value,
                ),
              ),
            ],
          );
        },
      );
}
