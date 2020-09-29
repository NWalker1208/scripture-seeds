import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/services/social_share_system.dart';
import 'package:intl/intl.dart';

class JournalEntryView extends StatelessWidget {
  final JournalEntry entry;
  final FutureOr<void> Function() onShare;

  JournalEntryView(this.entry, {this.onShare, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: entry.quote,
                        style: DefaultTextStyle.of(context).style.copyWith(height: 1.5, fontStyle: FontStyle.italic),

                        children: [
                          if (entry.quote != entry.reference)
                            WidgetSpan(
                              child: Text(
                                '  \u{2013} ${entry.reference}',
                                style: DefaultTextStyle.of(context).style.copyWith(height: 1.5)
                              ),
                            )
                        ]
                      )
                    ),
                    SizedBox(height: 4),

                    Text(
                      entry.commentary,
                      style: DefaultTextStyle.of(context).style.copyWith(height: 1.5)
                    ),
                    SizedBox(height: 8),

                    Text(DateFormat(
                      'M/d/yyyy').format(entry.created),
                      style: Theme.of(context).textTheme.caption
                    ),
                  ]
              ),
            ),
            SizedBox(width: 12.0),

            // Share Button
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () => SocialShareSystem.shareJournalEntry(
                entry: entry,
                onReturn: (success) {
                  if (success && onShare != null)
                    onShare();
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}

