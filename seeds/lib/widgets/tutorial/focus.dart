import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'overlay.dart';
import 'step.dart';

/// A widget which will be focused on when a tutorial is triggered.
class TutorialFocus extends StatefulWidget {
  const TutorialFocus(
    this.tag, {
    this.index = 0,
    this.overlayLabel,
    @required this.child,
    Key key,
  }) : super(key: key);

  final String tag;
  final int index;
  final Widget overlayLabel;
  final Widget child;

  @override
  TutorialFocusState createState() => TutorialFocusState();
}

class TutorialFocusState extends State<TutorialFocus> {
  final _boxKey = GlobalKey();
  final _link = OverlayLink();

  /// Show the tutorial overlay for this widget.
  Future<void> showOverlay(BuildContext context) {
    // Show placeholder
    assert(mounted);
    final box = _boxKey.currentContext.findRenderObject() as RenderBox;
    assert(box != null && box.hasSize);
    _link.placeholderSize.value = box.size;

    // Show dialog
    final themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context, rootNavigator: true).context,
    );
    Scrollable.ensureVisible(
      this.context,
      alignment: 0.5,
      duration: const Duration(milliseconds: 400),
    );
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, animation, __) => themes.wrap(_buildOverlay(animation)),
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionBuilder: (context, _, __, child) => child,
    );
  }

  Widget _buildOverlay(Animation<double> animation) {
    animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _link.placeholderSize.value = null;
      }
    });

    return TutorialOverlay(
      link: _link,
      child: widget.child,
      label: widget.overlayLabel,
      animation: animation,
    );
  }

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TutorialStep(
        widget.tag,
        index: widget.index,
        onStart: showOverlay,
        child: CompositedTransformTarget(
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
        ),
      );
}
