import 'package:flutter/material.dart';

import '../widgets/dashboard/journal.dart';
import '../widgets/dashboard/plants.dart';
import '../widgets/dashboard/topics.dart';
import '../widgets/help_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => HelpPage(
        'dashboard',
        title: 'Scripture Seeds',
        helpText: 'Welcome to Scripture Seeds! Select a topic to begin.',
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 150,
                pinned: true,
                stretch: true,
                flexibleSpace: const FlexibleSpaceBar(
                  titlePadding: EdgeInsets.all(16),
                  title: Text('Scripture Seeds'),
                  stretchModes: [StretchMode.fadeTitle],
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
