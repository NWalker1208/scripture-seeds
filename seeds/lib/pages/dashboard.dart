import 'package:flutter/material.dart';

import '../widgets/dashboard/journal.dart';
import '../widgets/dashboard/plants.dart';
import '../widgets/dashboard/topics.dart';
import '../widgets/tutorial/help_button.dart';
import '../widgets/tutorial/help_info.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
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
                HelpButton(),
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: 'Settings',
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
              ],
            ),

            // Dashboard items
            HelpInfo(
              title: 'Dashboard',
              helpText: 'Welcome to Scripture Seeds!\n\nFrom this page, '
                  'you can check on your plants, explore new topics, and '
                  'review your journal entries.',
              child: SliverList(
                delegate: SliverChildListDelegate(
                  const [
                    PlantsDashboard(),
                    Divider(),
                    TopicsDashboard(),
                    Divider(),
                    JournalDashboard()
                  ],
                ),
              ),
            )
          ],
        ),
      );
}
