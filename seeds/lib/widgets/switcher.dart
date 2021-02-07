import 'package:flutter/material.dart';

class AnimatedSizeSwitcher extends StatefulWidget {
  const AnimatedSizeSwitcher({
    this.child,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
    Key key,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  _AnimatedSizeSwitcherState createState() => _AnimatedSizeSwitcherState();
}

class _AnimatedSizeSwitcherState extends State<AnimatedSizeSwitcher>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => AnimatedSize(
        vsync: this,
        curve: widget.curve,
        duration: widget.duration,
        child: AnimatedSwitcher(
          duration: widget.duration,
          child: widget.child,
        ),
      );
}

class IconSwitcher extends StatelessWidget {
  const IconSwitcher(
    this.icon, {
    this.duration = const Duration(milliseconds: 200),
    Key key,
  }) : super(key: key);

  final IconData icon;
  final Duration duration;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: duration,
        child: Icon(icon, key: ValueKey(icon)),
      );
}
