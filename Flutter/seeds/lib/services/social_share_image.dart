import 'dart:async';
import 'package:social_share_plugin/social_share_plugin.dart';

enum SocialPlatform {
  FaceBook,
  Instagram,
  Twitter
}

class SocialShareImage {
  static void shareImage(String text, SocialPlatform platform, {FutureOr<void> Function(bool) onReturn}) {
    if (platform == SocialPlatform.FaceBook) {
      SocialSharePlugin.shareToFeedFacebook(
        caption: text,
        path: '',
        onSuccess: onReturn == null ? null : (id) async => onReturn(true),
        onCancel: onReturn == null ? null : () async => onReturn(false),
        onError: onReturn == null ? null : (e) async => onReturn(false),
      );

    } else if (platform == SocialPlatform.Instagram) {
      print('Not supported');
      onReturn(false);
      //SocialSharePlugin.shareToFeedInstagram(caption: text);

    } else if (platform == SocialPlatform.Twitter) {
      SocialSharePlugin.shareToTwitterLink(
        text: text,
        url: 'churchofjesuschrist.org',
        onSuccess: onReturn == null ? null : (id) async =>  onReturn(true),
        onCancel: onReturn == null ? null : () async => onReturn(false),
      );
    }
  }
}
