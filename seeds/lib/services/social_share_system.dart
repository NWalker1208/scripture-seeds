import 'dart:async';
import 'package:seeds/services/journal_data.dart';
import 'package:social_share/social_share.dart';

enum SharePlatform {
  system, // Only one implemented
  faceBook,
  instagram,
  twitter
}

class SocialShareSystem {
  static Future<void> shareJournalEntry({SharePlatform platform = SharePlatform.system,
      JournalEntry entry, FutureOr<void> Function(bool) onReturn}) async {
    bool success = false;

    if (platform == SharePlatform.system) {
      success = await SocialShare.shareOptions('${entry.reference}\n${entry.commentary}');
    } else {
      print('Error: Platform ${platform.toString()} not yet implemented.');
    }

    print("Shared to $platform, got $success");
    onReturn(success);
  }
}
