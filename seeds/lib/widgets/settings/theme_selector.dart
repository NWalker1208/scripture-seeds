import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/theme/provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: const Text('Theme'),
        trailing: Consumer<ThemeProvider>(
          builder: (context, theme, child) => DropdownButton<ThemeMode>(
            value: theme.mode,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (newMode) => theme.mode = newMode,
            items: <DropdownMenuItem<ThemeMode>>[
              const DropdownMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Text('System'),
              ),
              const DropdownMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              const DropdownMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Text('Dark'),
              )
            ],
          ),
        ),
      );
}
