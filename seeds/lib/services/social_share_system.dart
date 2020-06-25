import 'dart:async';
import 'package:social_share/social_share.dart';

enum SharePlatform {
  System, // Only one implemented
  FaceBook,
  Instagram,
  Twitter
}

class SocialShareSystem {
  static Future<void> shareScriptureQuote(SharePlatform platform, {String quote = '', String commentary = '', FutureOr<void> Function(bool) onReturn}) async {
    bool success = false;

    if (platform == SharePlatform.System) {
      success = await SocialShare.shareOptions('$quote\n$commentary');
    } else {
      print('Error: Platform ${platform.toString()} not yet implemented.');
    }

    print("Shared to $platform, got $success");
    onReturn(success);
  }
}
