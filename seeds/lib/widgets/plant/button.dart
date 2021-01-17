import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../services/progress/provider.dart';
import '../app_bar_themed.dart';
import 'status.dart';
import 'view.dart';

class PlantButton extends StatelessWidget {
  final String topic;

  PlantButton(this.topic, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.card,
        elevation: Theme.of(context).cardTheme.elevation,
        shape: Theme.of(context).cardTheme.shape,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            PlantView(
              topic,
              padding: EdgeInsets.fromLTRB(
                  20, 20, 20, Theme.of(context).buttonTheme.height + 4),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppBarThemed(Consumer<ProgressProvider>(
                  builder: (context, progress, child) =>
                      PlantStatus(progress.getProgressRecord(topic)),
                )),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: AppBarThemed(InkWell(
                  onTap: () => Navigator.of(context)
                      .pushNamed('/plant', arguments: topic))),
            )
          ],
        ),
      );
}
