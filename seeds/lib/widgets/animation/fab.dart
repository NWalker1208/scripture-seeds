import 'package:flutter/material.dart';

import 'switcher.dart';

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
        builder: (context, color, child) => FloatingActionButton(
          tooltip: tooltip,
          backgroundColor: color,
          disabledElevation: 2,
          onPressed: disabled ? null : onPressed,
          child: child,
        ),
        child: IconSwitcher(icon),
      );
}
