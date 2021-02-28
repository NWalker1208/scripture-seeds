import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/tutorial/provider.dart';
import '../utility/go.dart';
import '../widgets/dashboard/journal.dart';
import '../widgets/dashboard/plants.dart';
import '../widgets/dashboard/topics.dart';
import '../widgets/tutorial/button.dart';
import '../widgets/tutorial/help.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<TutorialProvider>(context).maybeShow(context, 'dashboard');
    return Scaffold(
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
              TutorialButton(),
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Settings',
                onPressed: () => Go.from(context).toSettings(),
              ),
            ],
          ),

          // Dashboard items
          TutorialHelp(
            'dashboard',
            index: 0,
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
}
