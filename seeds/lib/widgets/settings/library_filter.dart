import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../extensions/string.dart';
import '../../services/scriptures/volumes.dart';
import '../../services/settings/filter.dart';

class LibraryFilterSettings extends StatelessWidget {
  const LibraryFilterSettings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<FilterProvider>(
        builder: (context, filter, child) => Column(
          children: [
            const ListTile(
              title: Text('Study Sources', textAlign: TextAlign.center),
            ),
            ...Volume.values.map(
              (volume) => SwitchListTile(
                title: Text(StringExtension.fromEnum(volume).toTitle()),
                value: filter[volume],
                onChanged: (value) => filter[volume] = value,
              ),
            ),
          ],
        ),
      );
}
