import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:seeds/services/library/study_resource.dart';
import 'package:seeds/widgets/study_resource_display.dart';

class NewLibTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),

      body: Consumer<Library>(
        builder: (context, library, child) {
          return ListView(
            children: library.resources.map(
              (StudyResource res) => StudyResourceDisplay(res)
            ).toList(),
          );
        }
      )
    );
  }
}
