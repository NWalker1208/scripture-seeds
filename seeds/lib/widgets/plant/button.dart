import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/widgets/app_bar_themed.dart';

import '../../services/data/progress.dart';
import 'status.dart';
import 'view.dart';

class PlantButton extends StatelessWidget {
  final String topic;

  PlantButton(this.topic, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.card,
        elevation: 4,
        borderRadius: BorderRadius.circular(12.0),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            PlantView(
              topic,
              plantPadding: EdgeInsets.fromLTRB(
                  20, 20, 20, Theme.of(context).buttonTheme.height + 4),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppBarThemed(
                    Consumer<ProgressData>(
                      builder: (context, progress, child) =>
                          PlantStatus(progress.getProgressRecord(topic)),
                    ),
                  ),
                ),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                highlightColor:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.05),
                splashColor:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                onTap: () =>
                    Navigator.of(context).pushNamed('/plant', arguments: topic),
              ),
            )
          ],
        ),
      );
}
