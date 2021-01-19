import 'dart:async';

import 'package:social_share/social_share.dart';

import 'journal/entry.dart';

enum SharePlatform {
  system, // Only one implemented
  faceBook,
  instagram,
  twitter
}

class SocialShareSystem {
  static Future<void> shareJournalEntry({
    SharePlatform platform = SharePlatform.system,
    JournalEntry entry,
    FutureOr<void> Function(bool) onReturn,
  }) async {
    var success = false;

    if (platform == SharePlatform.system) {
      success = await SocialShare.shareOptions(entry.toString());
    } else {
      print('Error: Platform ${platform.toString()} not yet implemented.');
    }

    print('Shared to $platform, got $success');
    onReturn(success);
  }
}
