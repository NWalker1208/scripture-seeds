import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utility/custom_icons.dart';

const _scripturesUrl = 'https://scriptures.nephi.org';
const _privacyUrl = 'https://nwalker1208.github.io/walker-game-development/p/'
    'scripture-seeds-privacy-policy.html';

class CustomAboutDialog extends StatefulWidget {
  const CustomAboutDialog({Key key}) : super(key: key);

  @override
  _CustomAboutDialogState createState() => _CustomAboutDialogState();
}

class _CustomAboutDialogState extends State<CustomAboutDialog> {
  Future<PackageInfo> _packageInfo;
  GestureRecognizer _gestureRecognizer;

  Future<void> _openUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    _packageInfo = PackageInfo.fromPlatform();
    _gestureRecognizer = TapGestureRecognizer()
      ..onTap = () => _openUrl(_scripturesUrl);
    super.initState();
  }

  @override
  void dispose() {
    _gestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      const Text('App developed by Nathan Walker.'),
      const SizedBox(height: 8),
      const Text('Topics and references were obtained from '
          'ChurchOfJesusChrist.org and curated by Nathan Walker. '),
      const SizedBox(height: 8),
      Builder(
        builder: (context) {
          final style = DefaultTextStyle.of(context).style;
          return Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Scriptural text was obtained from the '),
                TextSpan(
                  text: 'LDS Documentation Project',
                  style: style.copyWith(
                    color: Colors.green,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: _gestureRecognizer,
                ),
                TextSpan(text: ' by Steve Dibb.')
              ],
            ),
          );
        },
      ),
      const SizedBox(height: 8),
      const Text('This app is not associated with the Church of Jesus Christ '
          'of Latter-Day Saints, and the views expressed do '
          'not represent those of the Church.'),
      const SizedBox(height: 8),
      ListTile(
        onTap: () => _openUrl(_privacyUrl),
        shape: ElevatedButtonTheme.of(context).style.shape.resolve({}),
        leading: const Icon(Icons.open_in_new),
        title: const Text('Privacy Policy'),
      )
    ];

    return FutureBuilder<PackageInfo>(
      future: _packageInfo,
      builder: (context, snapshot) => AboutDialog(
        applicationName: 'Scripture Seeds',
        applicationIcon: const Icon(CustomIcons.seeds, size: 40),
        applicationVersion:
            kIsWeb ? 'Web Version' : snapshot.data?.version ?? '...',
        children: children,
      ),
    );
  }
}
