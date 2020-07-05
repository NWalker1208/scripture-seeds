import 'package:flutter/material.dart';
import 'package:seeds/services/journal_data.dart';

class JournalEntryView extends StatelessWidget {
  final JournalEntry entry;

  JournalEntryView(this.entry);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.reference, style: DefaultTextStyle.of(context).style.copyWith(height: 1.5),),
              Text(entry.commentary, style: DefaultTextStyle.of(context).style.copyWith(height: 1.5),)
            ]
        ),
      ),
    );
  }
}

