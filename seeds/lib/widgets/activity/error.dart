import 'package:flutter/material.dart';

class ActivityError extends StatelessWidget {
  const ActivityError({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'We couldn\'t find anything to study!\n'
                'Try enabling more study sources in settings.',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
                onPressed: () =>
                    Navigator.of(context).popAndPushNamed('/settings'),
              )
            ],
          ),
        ),
      );
}
