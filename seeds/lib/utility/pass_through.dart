import 'package:flutter/gestures.dart';

/// A tap recognizer which will always accept a tap, even if others win
/// in the gesture arena.
class PassThroughTapRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    super.rejectGesture(pointer);
    onTap();
  }
}
