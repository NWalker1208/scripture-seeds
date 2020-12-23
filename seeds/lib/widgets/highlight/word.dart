import 'package:flutter/material.dart';

class HighlightTextWord extends StatefulWidget {
  final String text;
  final bool highlighted;
  final bool selected;
  final bool leftNeighbor;
  final bool rightNeighbor;
  final Color backgroundColor;
  final Color highlightColor;
  final TextStyle style;

  HighlightTextWord(
    this.text, {
    this.highlighted = false,
    this.selected = false,
    this.leftNeighbor = false,
    this.rightNeighbor = false,
    this.backgroundColor,
    this.highlightColor,
    this.style,
    Key key,
  }) : super(key: key);

  @override
  _HighlightTextWordState createState() => _HighlightTextWordState();
}

class _HighlightTextWordState extends State<HighlightTextWord>
    with TickerProviderStateMixin {
  bool _highlightVisible;
  AnimationController _highlightController;

  @override
  void initState() {
    _highlightVisible = widget.highlighted || widget.selected;
    _highlightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.selected ? 0.5 : (widget.highlighted ? 1 : 0),
    );
    super.initState();
  }

  @override
  void dispose() {
    _highlightController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HighlightTextWord oldWidget) {
    if (widget.selected) {
      if (!_highlightVisible) setState(() => _highlightVisible = true);
      if (!oldWidget.selected) _highlightController.animateTo(0.5);
    } else if (widget.highlighted) {
      if (!_highlightVisible) setState(() => _highlightVisible = true);
      if (oldWidget.selected || !oldWidget.highlighted) {
        _highlightController.animateTo(1);
      }
    } else {
      if (oldWidget.selected || oldWidget.highlighted) {
        _highlightController.animateTo(0).then((_) {
          if (_highlightVisible) setState(() => _highlightVisible = false);
        });
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColor =
        widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    var highlightColor = widget.highlightColor ??
        Theme.of(context).textSelectionTheme.selectionColor;
    var style = widget.style ?? DefaultTextStyle.of(context).style;

    var animation = CurvedAnimation(
      parent: _highlightController,
      curve: Curves.easeInOut,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Stack(
        children: <Widget>[
          // Highlight box
          if (_highlightVisible)
            Positioned.fill(
              child: FractionalTranslation(
                translation: const Offset(0, 0.08),
                child: Transform.scale(
                  scale: 1.01,
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      var color = Color.lerp(
                          backgroundColor, highlightColor, animation.value);

                      // Set corner radius based on if neighbors are active
                      var leftRadius = widget.leftNeighbor ? 0.0 : 6.0;
                      var rightRadius = widget.rightNeighbor ? 0.0 : 6.0;

                      // Animation builders for left and right corners of
                      // rounded highlight rectangle
                      return TweenAnimationBuilder<double>(
                        tween: Tween(end: leftRadius),
                        duration: const Duration(milliseconds: 200),
                        builder: (_, left, __) => TweenAnimationBuilder<double>(
                          tween: Tween(end: rightRadius),
                          duration: const Duration(milliseconds: 200),
                          builder: (_, right, __) => Container(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(left),
                                right: Radius.circular(right),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

          // Text of word
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(widget.text, style: style),
          )
        ],
      ),
    );
  }
}
