import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utility/cutout_clipper.dart';
import '../../utility/pass_through.dart';
import 'step.dart';

/// A widget which will be focused on when a tutorial is triggered.
class TutorialFocus extends StatefulWidget {
  const TutorialFocus(
    this.tag, {
    this.index = 0,
    this.overlayLabel,
    this.overlayShape = const Border(),
    this.overlayPadding = 4.0,
    @required this.child,
    Key key,
  }) : super(key: key);

  final String tag;
  final int index;
  final Widget overlayLabel;
  final ShapeBorder overlayShape;
  final double overlayPadding;
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

  /// Returns true if the overlay is not open (For usage with WillPopScope).
  Future<bool> closeOverlay() async {
    if (_overlayEntry == null) return true;
    await _overlayKey.currentState.close();
    return false;
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    final render = _childKey.currentContext.findRenderObject() as RenderBox;
    _overlayRect.value = (render.localToGlobal(Offset.zero) & render.size)
        .inflate(widget.overlayPadding);
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
        onWillPop: closeOverlay,
        child: TutorialStep(
          widget.tag,
          index: widget.index,
          onStart: showOverlay,
          child: RawGestureDetector(
            key: _childKey,
            child: widget.child,
            gestures: {
              PassThroughTapRecognizer: GestureRecognizerFactoryWithHandlers<
                  PassThroughTapRecognizer>(
                () => PassThroughTapRecognizer(), //constructor
                (instance) => instance..onTap = closeOverlay,
              )
            },
          ),
        ),
      );
}

class _FocusOverlay extends StatefulWidget {
  const _FocusOverlay({
    this.cutout,
    this.label,
    this.shape,
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ClipPath(
        clipper: CutoutClipper(widget.shape.getOuterPath(
          widget.cutout,
          textDirection: Directionality.of(context),
        )),
        child: GestureDetector(
          onTap: close,
          child: FadeTransition(
            opacity: CurvedAnimation(parent: _controller, curve: Curves.ease),
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
