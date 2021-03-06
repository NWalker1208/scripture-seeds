import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'router.dart';
import 'services/theme/provider.dart';

class SeedsApp extends StatefulWidget {
  const SeedsApp({
    Key key,
  }) : super(key: key);

  @override
  _SeedsAppState createState() => _SeedsAppState();
}

class _SeedsAppState extends State<SeedsApp> {
  final _routerDelegate = AppRouterDelegate();

  @override
  void dispose() {
    _routerDelegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return ChangeNotifierProvider.value(
      value: _routerDelegate,
      child: MaterialApp.router(
        title: 'Scripture Seeds',
        theme: theme.light,
        darkTheme: theme.dark,
        themeMode: theme.mode,
        routerDelegate: _routerDelegate,
        routeInformationParser: const AppRouteInformationParser(),
      ),
    );
  }
}
