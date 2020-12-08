import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pedantic/pedantic.dart';

import '../../services/library/manager.dart';

class LibraryRefreshTile extends StatefulWidget {
  const LibraryRefreshTile({Key key}) : super(key: key);

  @override
  _LibraryRefreshTileState createState() => _LibraryRefreshTileState();
}

class _LibraryRefreshTileState extends State<LibraryRefreshTile>
    with TickerProviderStateMixin {
  AnimationController _controller;

  void _resetLibraryCache(BuildContext context) async {
    unawaited(_controller.repeat());

    var libManager = Provider.of<LibraryManager>(context, listen: false);
    var success = await libManager.refreshLibrary();

    _controller.reset();
    ScaffoldMessenger.of(context).showSnackBar(
      success
          ? const SnackBar(content: Text('Library is up to date.'))
          : const SnackBar(content: Text('Unable to download library.')),
    );
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListTile(
        leading: RotationTransition(
          turns: _controller,
          child: const Icon(Icons.refresh),
        ),
        title: const Text('Refresh Library'),
        subtitle: Consumer<LibraryManager>(
          builder: (context, libManager, child) {
            if (libManager.lastRefresh == null) {
              return Text('Last refresh: Never');
            } else {
              return Text(
                  'Last refresh: ${DateFormat('h:mm a, M/d/yyyy').format(libManager.lastRefresh)}');
            }
          },
        ),
        onTap: () => _resetLibraryCache(context),
      );
}
