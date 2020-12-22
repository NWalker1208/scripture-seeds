import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/scriptures/volumes.dart';
import '../../services/settings/study_filter.dart';
import '../../services/utility.dart';

class LibraryFilterSettings extends StatelessWidget {
  const LibraryFilterSettings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer<StudyFilter>(
        builder: (context, filter, child) => Column(
            children: [
              const ListTile(
                title: Text('Study Sources', textAlign: TextAlign.center),
              ),
              ...Volume.values.map(
                (volume) => SwitchListTile(
                  title: Text(enumToString(volume).toTitle()),
                  value: filter[volume],
                  onChanged: (value) => filter[volume] = value,
                ),
              ),
            ],
          ),
      );
}
