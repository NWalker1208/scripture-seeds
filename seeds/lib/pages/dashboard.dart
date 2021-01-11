import 'package:flutter/material.dart';

import '../widgets/dashboard/journal.dart';
import '../widgets/dashboard/plants.dart';
import '../widgets/dashboard/topics.dart';
import '../widgets/help_info.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => HelpInfo(
        'dashboard',
        title: 'Welcome!',
        helpText: 'To begin, select a topic that you would like to study.',
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                stretch: true,
                forceElevated: true,
                flexibleSpace: const FlexibleSpaceBar(
                  titlePadding: EdgeInsets.all(16),
                  title: Text('Scripture Seeds'),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => Navigator.pushNamed(context, '/settings'),
                  )
                ],
              ),

              // Dashboard items
              SliverList(
                delegate: SliverChildListDelegate(
                  const [
                    PlantsDashboard(),
                    Divider(),
                    TopicsDashboard(),
                    Divider(),
                    JournalDashboard()
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
