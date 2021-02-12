import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utility/custom_icons.dart';

const _scripturesUrl = 'https://scriptures.nephi.org';

class CustomAboutDialog extends StatefulWidget {
  const CustomAboutDialog({Key key}) : super(key: key);

  @override
  _CustomAboutDialogState createState() => _CustomAboutDialogState();
}

class _CustomAboutDialogState extends State<CustomAboutDialog> {
  Future<PackageInfo> _packageInfo;
  GestureRecognizer _gestureRecognizer;

  @override
  void initState() {
    _packageInfo = PackageInfo.fromPlatform();
    _gestureRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        if (await canLaunch(_scripturesUrl)) {
          await launch(_scripturesUrl);
        }
      };
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
      const Text('Topical information is compiled from '
          'ChurchOfJesusChrist.org and curated by Nathan Walker. '),
      const SizedBox(height: 8),
      const Text('This app is not associated with the Church of Jesus Christ '
          'of Latter-Day Saints, and the views expressed do '
          'not represent those of the Church.'),
      const SizedBox(height: 8),
      const Text('Scriptural text is made available by the '
          '"LDS Documentation Project" by Steve Dibb. Visit this page for '
          'more info:'),
      const SizedBox(height: 8),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: _scripturesUrl,
          style: DefaultTextStyle.of(context).style.copyWith(
              color: Colors.green, decoration: TextDecoration.underline),
          recognizer: _gestureRecognizer,
        ),
      )
    ];

    return FutureBuilder<PackageInfo>(
      future: _packageInfo,
      builder: (context, snapshot) => AboutDialog(
        applicationName: 'Scripture Seeds',
        applicationIcon: const Icon(CustomIcons.seeds, size: 40),
        applicationVersion: snapshot.data?.version ?? '...',
        children: children,
      ),
    );
  }
}
