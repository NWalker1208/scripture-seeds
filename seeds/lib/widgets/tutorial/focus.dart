import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utility/cutout_clipper.dart';
import '../../utility/pass_through.dart';
import 'step.dart';

const defaultOverlayShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)));

/// A widget which will be focused on when a tutorial is triggered.
class TutorialFocus extends StatefulWidget {
  const TutorialFocus(
    this.tag, {
    this.index = 0,
    this.overlayLabel,
    this.overlayShape = defaultOverlayShape,
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
  OverlayEntry _overlayEntry;
  Completer<void> _overlayCompleter;

  /// Show the tutorial overlay for this widget.
  Future<void> showOverlay(BuildContext context) async {
    await Scrollable.ensureVisible(
      this.context,
      alignment: 0.5,
      duration: const Duration(milliseconds: 400),
    );
    if (_overlayEntry != null) _overlayEntry.remove();
    _overlayCompleter = Completer<void>();
    _overlayEntry = OverlayEntry(
      maintainState: true,
      builder: (context) => _FocusOverlay(
        key: _overlayKey,
        initialCutout: _getCutout(),
        label: widget.overlayLabel,
        shape: widget.overlayShape,
        onDismiss: _disposeOverlay,
      ),
    );
    _updateOverlay();

    Overlay.of(context).insert(_overlayEntry);
    return _overlayCompleter.future;
  }

  Future<void> closeOverlay() => _overlayKey.currentState?.close();

  Rect _getCutout() {
    final render = _childKey.currentContext.findRenderObject() as RenderBox;
    if (!render.hasSize) return Rect.zero;
    return (render.localToGlobal(Offset.zero) & render.size)
        .inflate(widget.overlayPadding);
  }

  void _disposeOverlay() {
    _overlayEntry?.remove();
    _overlayCompleter?.complete();
    _overlayEntry = null;
    _overlayCompleter = null;
  }

  void _updateOverlay() {
    _overlayKey.currentState?.cutout = _getCutout();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_overlayEntry != null) _updateOverlay();
    });
  }

  @override
  void dispose() {
    _disposeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (_overlayEntry == null) return true;
          await closeOverlay();
          return false;
        },
        child: TutorialStep(
          widget.tag,
          index: widget.index,
          onStart: showOverlay,
          child: RawGestureDetector(
            key: _childKey,
            gestures: {
              PassThroughTapRecognizer: GestureRecognizerFactoryWithHandlers<
                  PassThroughTapRecognizer>(
                () => PassThroughTapRecognizer(), //constructor
                (instance) => instance..onTap = closeOverlay,
              )
            },
            child: widget.child,
          ),
        ),
      );
}

class _FocusOverlay extends StatefulWidget {
  const _FocusOverlay({
    this.initialCutout,
    this.label,
    this.shape,
    this.onDismiss,
    Key key,
  }) : super(key: key);

  final Rect initialCutout;
  final Widget label;
  final ShapeBorder shape;
  final void Function() onDismiss;

  @override
  _FocusOverlayState createState() => _FocusOverlayState();
}

class _FocusOverlayState extends State<_FocusOverlay>
    with SingleTickerProviderStateMixin {
  Rect _cutout;
  AnimationController _controller;

  Rect get cutout => _cutout;
  set cutout(Rect value) => setState(() => _cutout = value);

  Future<void> close() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void initState() {
    _cutout = widget.initialCutout;
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
          _cutout,
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
                    top: _cutout.top - 8,
                    left: _cutout.left,
                    width: _cutout.width,
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
