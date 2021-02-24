import 'package:flutter/material.dart';

typedef TutorialStarter = Future<void> Function(BuildContext);

/// Marks a step for the tutorial with the given tag.
class TutorialStep extends StatelessWidget {
  const TutorialStep(
    this.tag, {
    this.index = 0,
    @required this.onStart,
    this.child,
    Key key,
  }) : super(key: key);

  final String tag;
  final int index;
  final TutorialStarter onStart;
  final Widget child;

  static Iterable<TutorialStep> of(BuildContext context, [String tag]) {
    final result = <TutorialStep>[];

    void visitor(Element element) {
      final widget = element.widget;
      if (widget is TutorialStep) result.add(widget);
      element.visitChildren(visitor);
    }

    context.visitChildElements(visitor);
    if (tag != null) result.removeWhere((widget) => widget.tag != tag);
    return result..sort((a, b) => a.index.compareTo(b.index));
  }

  @override
  Widget build(BuildContext context) => child ?? Container();
}
