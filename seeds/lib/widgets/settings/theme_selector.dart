import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/settings/theme.dart';

class ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Theme', style: Theme.of(context).textTheme.subtitle1),
        SizedBox(width: 16),

        Consumer<ThemePreference>(
          builder: (context, setting, child) => DropdownButton<ThemeMode>(
            value: setting.mode,
            icon: Icon(Icons.arrow_drop_down),
            onChanged: (newMode) => setting.mode = newMode,

            items: <DropdownMenuItem<ThemeMode>>[
              DropdownMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Text('System'),
              ),
              DropdownMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              DropdownMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Text('Dark'),
              )
            ]
          ),
        )
      ],
    );
  }
}
