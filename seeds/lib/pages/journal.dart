import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/widgets/journal_entry.dart';

class JournalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('My Journal')
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<JournalData>(
          builder: (context, journal, child) {
            return ListView.builder(
              itemCount: journal.entries.length,
              itemBuilder: (context, index) => JournalEntryView(journal.entries[index])
            );
          },
        ),
      ),
    );
  }
}
