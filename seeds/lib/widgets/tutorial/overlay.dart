import 'package:flutter/material.dart';

class OverlayLink {
  final transform = LayerLink();
  final overlayConstraints = ValueNotifier<BoxConstraints>(null);
  final placeholderSize = ValueNotifier<Size>(null);

  void dispose() {
    overlayConstraints.dispose();
    placeholderSize.dispose();
  }
}

class TutorialOverlay extends StatefulWidget {
  const TutorialOverlay({
    this.child,
    this.label,
    this.link,
    this.animation,
    this.spacing = 8,
    Key key,
  }) : super(key: key);

  final Widget child;
  final Widget label;
  final OverlayLink link;
  final Animation<double> animation;
  final double spacing;

  @override
  _TutorialOverlayState createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  final _overlayKey = GlobalKey();

  void updateSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = _overlayKey.currentContext.findRenderObject() as RenderBox;
      widget.link.placeholderSize.value = box.size;
    });
  }

  Widget buildLabel(BuildContext context) => DefaultTextStyle(
        style: Theme.of(context).textTheme.subtitle1.copyWith(
          color: Colors.white,
          shadows: [Shadow(blurRadius: 4)],
        ),
        child: widget.label,
      );

  Widget buildOverlay() => UnconstrainedBox(
        child: NotificationListener<SizeChangedLayoutNotification>(
          onNotification: (notification) {
            updateSize();
            return true;
          },
          child: SizeChangedLayoutNotifier(
            child: ValueListenableBuilder<BoxConstraints>(
              valueListenable: widget.link.overlayConstraints,
              child: widget.child,
              builder: (context, constraints, child) => ConstrainedBox(
                key: _overlayKey,
                constraints: constraints,
                child: child,
              ),
            ),
          ),
        ),
      );

  @override
  void initState() {
    updateSize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CompositedTransformFollower(
              link: widget.link.transform,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: IgnorePointer(child: buildOverlay()),
              ),
            ),
            if (widget.label != null)
              CompositedTransformFollower(
                link: widget.link.transform,
                targetAnchor: Alignment.topCenter,
                followerAnchor: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: widget.spacing),
                  child: FadeTransition(
                    opacity:
                        widget.animation ?? const AlwaysStoppedAnimation(1.0),
                    child: buildLabel(context),
                  ),
                ),
              ),
          ],
        ),
      );
}
