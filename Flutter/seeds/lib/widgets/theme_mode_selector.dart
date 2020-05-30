import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/theme_mode_setting.dart';

class ThemeModeSelector extends StatefulWidget {
  @override
  _ThemeModeSelectorState createState() => _ThemeModeSelectorState();
}

class _ThemeModeSelectorState extends State<ThemeModeSelector> {
  void setMode(BuildContext context, ThemeMode newMode) {
    Provider.of<ThemeModeSetting>(context, listen: false).mode = newMode;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeSetting>(
      builder: (context, setting, child) => DropdownButton<ThemeMode>(
        value: setting.mode,
        icon: Icon(Icons.arrow_drop_down),
        onChanged: (newMode) => setMode(context, newMode),

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
    );
  }
}

