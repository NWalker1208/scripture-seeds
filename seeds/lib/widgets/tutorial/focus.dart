import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../cutout_clipper.dart';
import 'step.dart';

/// A widget which will be focused on when a tutorial is triggered.
class TutorialFocus extends StatefulWidget {
  const TutorialFocus(
    this.tag, {
    this.index = 0,
    this.overlayLabel,
    this.overlayShape = const CircleBorder(),
    @required this.child,
    Key key,
  }) : super(key: key);

  final String tag;
  final int index;
  final Widget overlayLabel;
  final ShapeBorder overlayShape;
  final Widget child;

  @override
  TutorialFocusState createState() => TutorialFocusState();
}

class TutorialFocusState extends State<TutorialFocus> {
  final _childKey = GlobalKey();
  final _overlayKey = GlobalKey<_FocusOverlayState>();
  final _overlayRect = ValueNotifier<Rect>(null);
  OverlayEntry _overlayEntry;

  /// Show the tutorial overlay for this widget.
  Future<void> showOverlay(BuildContext context) async {
    await Scrollable.ensureVisible(
      this.context,
      alignment: 0.5,
      duration: const Duration(milliseconds: 400),
    );
    if (_overlayEntry != null) _overlayEntry.remove();

    _overlayEntry = OverlayEntry(
      maintainState: true,
      builder: (context) => ValueListenableBuilder<Rect>(
        valueListenable: _overlayRect,
        builder: (context, rect, child) => _FocusOverlay(
          key: _overlayKey,
          cutout: rect,
          label: widget.overlayLabel,
          shape: widget.overlayShape,
          onDismiss: _hideOverlay,
        ),
      ),
    );
    _updateOverlay();

    Overlay.of(context).insert(_overlayEntry);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    final render = _childKey.currentContext.findRenderObject() as RenderBox;
    _overlayRect.value =
        (render.localToGlobal(Offset.zero) & render.size); //.inflate(8.0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_overlayEntry != null) _updateOverlay();
    });
  }

  @override
  void dispose() {
    _hideOverlay();
    _overlayRect.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (_overlayEntry == null) return true;
          await _overlayKey.currentState.close();
          return false;
        },
        child: TutorialStep(
          widget.tag,
          index: widget.index,
          onStart: showOverlay,
          child: SizedBox(key: _childKey, child: widget.child),
        ),
      );
}

class _FocusOverlay extends StatefulWidget {
  const _FocusOverlay({
    this.cutout,
    this.label,
    this.shape = const CircleBorder(),
    this.onDismiss,
    Key key,
  }) : super(key: key);

  final Rect cutout;
  final Widget label;
  final ShapeBorder shape;
  final void Function() onDismiss;

  @override
  _FocusOverlayState createState() => _FocusOverlayState();
}

class _FocusOverlayState extends State<_FocusOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Future<void> close() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void initState() {
    _controller = AnimationController(
      value: 0,
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: CurvedAnimation(parent: _controller, curve: Curves.ease),
        child: ClipPath(
          clipper: CutoutClipper(widget.shape.getOuterPath(widget.cutout)),
          child: GestureDetector(
            onTap: close,
            child: Stack(
              children: [
                Container(color: Colors.black54),
                if (widget.label != null)
                  Positioned(
                    top: widget.cutout.top - 8,
                    left: widget.cutout.left,
                    width: widget.cutout.width,
                    height: 0,
                    child: OverflowBox(
                      alignment: Alignment.bottomCenter,
                      minWidth: 0,
                      minHeight: 0,
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DefaultTextStyle.merge(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            child: widget.label,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
