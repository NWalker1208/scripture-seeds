// Credit to: https://gist.github.com/Laim0n/e1b70f5d841e47c9d85ccdf6ae866984
import 'package:flutter/material.dart';

class AnimatedIndexedStack extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  final int index;
  final List<Widget> children;

  const AnimatedIndexedStack({
    Key key,
    this.duration,
    this.curve = Curves.ease,
    this.index,
    this.children,
  }) : super(key: key);

  @override
  _AnimatedIndexedStackState createState() => _AnimatedIndexedStackState();
}

class _AnimatedIndexedStackState extends State<AnimatedIndexedStack>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  int _index;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    _index = widget.index;
    _controller.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != _index) {
      _controller.reverse().then((_) {
        setState(() => _index = widget.index);
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Opacity(
          opacity: _controller.value,
          //child: Transform.scale(
          //  scale: 1.015 - (_controller.value * 0.015),
          child: child,
          //),
        ),
        child: IndexedStack(
          index: _index,
          children: widget.children,
        ),
      );
}
