import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/tutorial/provider.dart';
import 'overlay.dart';

typedef OverlayBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);

/// A widget which will be focused on when a tutorial is triggered.
class TutorialFocus extends StatefulWidget {
  const TutorialFocus({
    @required this.child,
    this.tag,
    this.priority = 0,
    this.overlayLabel,
    this.overlayBuilder,
    Key key,
  }) : super(key: key);

  final Widget child;
  final String tag;
  final int priority;
  final Widget overlayLabel;
  final OverlayBuilder overlayBuilder;

  static Iterable<TutorialFocusState> allIn(BuildContext context) {
    final result = <TutorialFocusState>[];

    void visitor(Element element) {
      if (element.widget is TutorialFocus) {
        final focus = element as StatefulElement;
        result.add(focus.state as TutorialFocusState);
      }
      element.visitChildren(visitor);
    }

    context.visitChildElements(visitor);
    return result
      ..sort((a, b) => a.widget.priority.compareTo(b.widget.priority));
  }

  @override
  TutorialFocusState createState() => TutorialFocusState();
}

class TutorialFocusState extends State<TutorialFocus> {
  final _boxKey = GlobalKey();
  final _link = FocusOverlayLink();

  /// Show the tutorial overlay for this widget.
  Future<void> showOverlay() async {
    // Show placeholder
    assert(mounted);
    final box = _boxKey.currentContext.findRenderObject() as RenderBox;
    assert(box != null && box.hasSize);
    _link.placeholderSize.value = box.size;

    // Show dialog
    final themes = InheritedTheme.capture(
        from: context, to: Navigator.of(context, rootNavigator: true).context);
    await showGeneralDialog(
      context: context,
      pageBuilder: (_, animation, __) => themes.wrap(_buildOverlay(animation)),
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionBuilder: (context, _, __, child) => child,
    );
  }

  /// Hides placeholder once closing animation completes.
  void _pageAnimationListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _link.placeholderSize.value = null;
    }
  }

  Widget _buildOverlay(Animation<double> animation) {
    var child = widget.child;
    if (widget.overlayBuilder != null) {
      child = Builder(
        builder: (context) => widget.overlayBuilder(context, animation, child),
      );
    }

    animation.addStatusListener(_pageAnimationListener);
    return TutorialOverlay(
      link: _link,
      child: child,
      label: widget.overlayLabel,
      animation: animation,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TutorialProvider>(context, listen: false).showTutorial(this);
    });
    super.initState();
  }

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
        link: _link.transform,
        child: LayoutBuilder(
          builder: (context, constraints) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => _link.overlayConstraints.value = constraints);
            return ValueListenableBuilder<Size>(
              valueListenable: _link.placeholderSize,
              builder: (context, size, child) => SizedBox.fromSize(
                key: _boxKey,
                size: size,
                child: size == null ? widget.child : null,
              ),
            );
          },
        ),
      );
}
