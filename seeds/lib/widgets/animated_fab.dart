import 'package:flutter/material.dart';

class AnimatedFloatingActionButton extends StatelessWidget {
  const AnimatedFloatingActionButton({
    this.icon,
    this.tooltip,
    this.disabled = false,
    this.backgroundColor,
    @required this.onPressed,
    Key key,
  }) : super(key: key);

  final IconData icon;
  final String tooltip;
  final bool disabled;
  final Color backgroundColor;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<Color>(
        duration: const Duration(milliseconds: 200),
        tween: ColorTween(
          end: disabled
              ? Theme.of(context).disabledColor
              : backgroundColor ?? Theme.of(context).accentColor,
        ),
        child: Icon(icon, key: ValueKey(icon)),
        builder: (context, color, child) => FloatingActionButton(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: child,
          ),
          tooltip: tooltip,
          backgroundColor: color,
          disabledElevation: 2,
          onPressed: disabled ? null : onPressed,
        ),
      );
}
