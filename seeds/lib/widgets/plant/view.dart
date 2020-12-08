import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/data/progress.dart';
import '../../services/data/progress_record.dart';
import 'painter.dart';

class PlantView extends StatefulWidget {
  final String plantName;
  final EdgeInsetsGeometry plantPadding;
  final Widget child;

  PlantView(
    this.plantName, {
    this.plantPadding = const EdgeInsets.all(20),
    this.child,
    Key key,
  }) : super(key: key);

  @override
  _PlantViewState createState() => _PlantViewState();
}

class _PlantViewState extends State<PlantView> {
  ProgressRecord _record;

  static final Color kDayColor = Colors.lightBlue[200];
  static final Color kNightColor = Colors.indigo[900];

  Color _getSkyColor(double light) => Color.lerp(kNightColor, kDayColor, light);

  @override
  void didChangeDependencies() {
    var progressData = Provider.of<ProgressData>(context);
    _record = progressData.getProgressRecord(widget.plantName);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Color skyColor;

    if (Theme.of(context).brightness == Brightness.light) {
      skyColor = _getSkyColor(1);
    } else if (Theme.of(context).brightness == Brightness.dark) {
      skyColor = _getSkyColor(0);
    }

    return Stack(
      children: [
        Hero(
          tag: 'plant_view_${widget.plantName}',
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color.lerp(skyColor, Colors.white, 0.2), skyColor],
                stops: const [0, 1],
              ),
            ),
            child: Stack(
              children: [
                // Plant Renderer
                Padding(
                  padding: widget.plantPadding,
                  child: LayoutBuilder(
                    builder: (context, constraints) =>
                        TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: _record.progressPercent + _record.lostPercent,
                        end: _record.progressPercent,
                      ),
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeInOutCubic,
                      builder: (context, progress, child) => CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: PlantPainter(
                          growth: progress,
                          wilted: _record.progressLost != null,
                          fruit: _record.rewardAvailable,
                        ),
                      ),
                    ),
                  ),
                ),

                // Dirt Box
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: widget.plantPadding
                      .resolve(Directionality.of(context))
                      .bottom,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.brown[800]),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Child
        if (widget.child != null) widget.child
      ],
    );
  }
}
