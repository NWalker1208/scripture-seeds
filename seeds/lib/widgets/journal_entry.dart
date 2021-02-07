import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/journal/entry.dart';
import '../services/scriptures/reference.dart';
import '../utility/social_share_system.dart';

class JournalEntryView extends StatelessWidget {
  final JournalEntry entry;
  final FutureOr<void> Function() onShare;

  JournalEntryView(
    this.entry, {
    this.onShare,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScriptureReference reference;
    try {
      reference = ScriptureReference.parse(entry.reference);
    } on Exception {
      print('Journal entry had invalid reference.');
      reference = null;
    }

    return Card(
      color: Theme.of(context).colorScheme.primaryVariant,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: '\u{201C}${entry.quote}\u{201D} ',
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(height: 1.5, fontStyle: FontStyle.italic),
                      children: [
                        // WidgetSpan prevents the reference from being broken
                        // into multiple lines.
                        WidgetSpan(
                          child: Text(
                            '\u{2013} ${entry.reference}',
                            style: DefaultTextStyle.of(context).style.copyWith(
                                height: 1.5, fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Gospel Library Button
                if (reference != null) ...[
                  SizedBox(width: 4),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.open_in_new),
                    tooltip: 'Open in Gospel Library',
                    onPressed: reference.openInGospelLibrary,
                  ),
                ]
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.commentary,
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(height: 1.5),
                      ),
                      SizedBox(height: 8),
                      Text(
                        DateFormat('M/d/yyyy').format(entry.created),
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.share),
                  tooltip: 'Share',
                  onPressed: () => SocialShareSystem.shareJournalEntry(
                    entry: entry,
                    onReturn: (success) {
                      if (success && onShare != null) onShare();
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
