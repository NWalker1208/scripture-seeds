import 'package:flutter/material.dart';
import 'package:seeds/widgets/dashboard/plants.dart';
import 'package:seeds/widgets/dashboard/topics.dart';
import 'package:seeds/widgets/dashboard/journal.dart';
import 'package:seeds/widgets/help_page.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpPage(
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

              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.all(16),
                title:  Text('Scripture Seeds'),
                stretchModes: [StretchMode.fadeTitle],
              ),

              actions: [
                /*IconButton(
                  icon: Icon(Icons.search),
                ),*/
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                )
              ],
            ),

            // Dashboard items
            SliverList(
              delegate: SliverChildListDelegate([
                PlantsDashboard(),
                Divider(),
                TopicsDashboard(),
                Divider(),
                JournalDashboard()
              ]),
            )
          ],
        ),
      ),
    );
  }
}