import 'package:flutter/material.dart';

class FocusOverlayLink {
  final transform = LayerLink();
  final overlayConstraints = ValueNotifier<BoxConstraints>(null);
  final placeholderSize = ValueNotifier<Size>(null);

  void dispose() {
    overlayConstraints.dispose();
    placeholderSize.dispose();
  }
}

class TutorialOverlay extends StatelessWidget {
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
  final FocusOverlayLink link;
  final Animation<double> animation;
  final double spacing;

  Widget _buildLabel(BuildContext context) => DefaultTextStyle(
        style: Theme.of(context).textTheme.subtitle1.copyWith(
          color: Colors.white,
          shadows: [Shadow(blurRadius: 4)],
        ),
        child: label,
      );

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CompositedTransformFollower(
              link: link.transform,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: IgnorePointer(
                  child: UnconstrainedBox(
                    child: ValueListenableBuilder<BoxConstraints>(
                      valueListenable: link.overlayConstraints,
                      child: child,
                      builder: (context, constraints, child) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final box = context.findRenderObject() as RenderBox;
                          link.placeholderSize.value = box.size;
                        });
                        return ConstrainedBox(
                          constraints: constraints,
                          child: child,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (label != null)
              CompositedTransformFollower(
                link: link.transform,
                targetAnchor: Alignment.topCenter,
                followerAnchor: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: spacing),
                  child: FadeTransition(
                    opacity: animation ?? const AlwaysStoppedAnimation(1.0),
                    child: _buildLabel(context),
                  ),
                ),
              ),
          ],
        ),
      );
}
