import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../services/topics/provider.dart';

class LibraryRefreshTile extends StatefulWidget {
  const LibraryRefreshTile({Key key}) : super(key: key);

  @override
  _LibraryRefreshTileState createState() => _LibraryRefreshTileState();
}

class _LibraryRefreshTileState extends State<LibraryRefreshTile>
    with TickerProviderStateMixin {
  static final _dateFormat = DateFormat('h:mm a, M/d/yyyy');
  AnimationController _controller;

  void _refreshTopics(BuildContext context) {
    var topics = Provider.of<TopicIndexProvider>(context, listen: false);
    _controller.repeat();

    topics.refresh()
      ..then((success) => ScaffoldMessenger.of(context).showSnackBar(
            success
                ? const SnackBar(content: Text('Library is up to date.'))
                : const SnackBar(content: Text('Unable to download library.')),
          ))
      ..whenComplete(() => _controller.animateTo(1, curve: Curves.easeOut));
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
        subtitle: Consumer<TopicIndexProvider>(
          builder: (context, topics, child) {
            if (topics.lastRefresh == null) {
              return Text('Last refresh: Never');
            } else {
              return Text('Last refresh: '
                  '${_dateFormat.format(topics.lastRefresh)}');
            }
          },
        ),
        onTap: () => _refreshTopics(context),
      );
}
