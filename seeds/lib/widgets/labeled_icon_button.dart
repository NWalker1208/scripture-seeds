import 'package:flutter/material.dart';

class LabeledIconButton extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;
  final String label;

  const LabeledIconButton({
    @required this.icon,
    @required this.onPressed,
    this.label = '',
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Text(
            label,
            style: BottomNavigationBarTheme.of(context).unselectedLabelStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: IconButton(
              icon: icon,
              tooltip: label,
              onPressed: onPressed,
            ),
          ),
        ],
      );
}
