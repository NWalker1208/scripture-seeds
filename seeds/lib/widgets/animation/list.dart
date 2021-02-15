import 'package:flutter/widgets.dart';

import '../../extensions/list.dart';

typedef IndexedViewBuilder = Widget Function(
  BuildContext context,
  int itemCount,
  IndexedWidgetBuilder itemBuilder,
);

typedef ListViewBuilder = Widget Function(
  BuildContext context,
  List<Widget> children,
);

typedef AnimatedItemBuilder<T> = Widget Function(
  BuildContext context,
  T value,
  Animation<double> animation,
);

IndexedViewBuilder _listToIndexedViewBuilder(ListViewBuilder viewBuilder) =>
    (context, count, builder) => viewBuilder(
          context,
          List.generate(count, (index) => builder(context, index)),
        );

class AnimatedListBuilder<T> extends StatefulWidget {
  AnimatedListBuilder({
    this.items = const [],
    @required this.viewBuilder,
    @required this.itemBuilder,
    @required this.duration,
    this.insertDelay = const Duration(),
    this.removeDelay = const Duration(),
    Key key,
  }) : super(key: key);

  AnimatedListBuilder.list({
    this.items = const [],
    @required ListViewBuilder viewBuilder,
    @required this.itemBuilder,
    @required this.duration,
    this.insertDelay = const Duration(),
    this.removeDelay = const Duration(),
    Key key,
  })  : viewBuilder = _listToIndexedViewBuilder(viewBuilder),
        super(key: key);

  final Iterable<T> items;
  final IndexedViewBuilder viewBuilder;
  final AnimatedItemBuilder<T> itemBuilder;
  final Duration duration;
  final Duration insertDelay;
  final Duration removeDelay;

  @override
  _AnimatedListBuilderState<T> createState() => _AnimatedListBuilderState<T>();
}

class _ItemController<T> {
  T item;
  AnimationController controller;

  _ItemController(this.item, this.controller);
}

class _AnimatedListBuilderState<T> extends State<AnimatedListBuilder<T>>
    with TickerProviderStateMixin {
  List<_ItemController<T>> visibleItems;
  Interval forwardInterval;
  Interval reverseInterval;

  /// Creates an item controller for the given item.
  _ItemController<T> createController(T item, {bool startVisible = false}) =>
      _ItemController(
        item,
        AnimationController(
          vsync: this,
          duration: widget.insertDelay + widget.duration,
          reverseDuration: widget.duration + widget.removeDelay,
          value: startVisible ? 1 : 0,
        ),
      );

  /// Updates all controllers with the current durations of the widget.
  void updateDurations() {
    final forward = widget.insertDelay + widget.duration;
    final reverse = widget.duration + widget.removeDelay;
    for (var item in visibleItems) {
      item.controller.duration = forward;
      item.controller.reverseDuration = reverse;
    }
  }

  /// Calculates the percentage of the total duration that the delay creates.
  double getIntervalDelay(Duration delay) =>
      delay.inMilliseconds /
      (widget.duration.inMilliseconds + delay.inMilliseconds);

  /// Updates items based on the difference between oldItems and newItems.
  void updateVisibleItems() {
    var comparison = visibleItems.compareTo<T>(
      widget.items,
      compare: (controller, item) => controller.item == item,
      convert: createController,
    );

    // Start removal animations for removed items.
    for (var oldItem in comparison.oldItems) {
      oldItem.controller.reverse().then((_) => setState(() {
            visibleItems.remove(oldItem);
            oldItem.controller.dispose();
          }));
    }

    // Start insertion animations for added items.
    for (var newItem in comparison.newItems) {
      newItem.controller.forward();
    }

    // TODO: Trigger forward animation on all items not being removed

    setState(() => visibleItems = comparison.merged);
  }

  @override
  void initState() {
    forwardInterval = Interval(getIntervalDelay(widget.insertDelay), 1);
    reverseInterval = Interval(0, 1 - getIntervalDelay(widget.removeDelay));
    visibleItems = [
      for (var item in widget.items) createController(item, startVisible: true),
    ];
    super.initState();
  }

  @override
  void dispose() {
    for (var item in visibleItems) {
      item.controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedListBuilder<T> oldWidget) {
    if (widget.duration != oldWidget.duration ||
        widget.insertDelay != oldWidget.insertDelay ||
        widget.removeDelay != oldWidget.removeDelay) {
      forwardInterval = Interval(getIntervalDelay(widget.insertDelay), 1);
      reverseInterval = Interval(0, 1 - getIntervalDelay(widget.removeDelay));
      updateDurations();
    }
    updateVisibleItems();
    super.didUpdateWidget(oldWidget);
  }

  Widget buildItem(T item, AnimationController animation) => AnimatedBuilder(
        key: ValueKey(item),
        animation: animation,
        builder: (context, child) =>
            IgnorePointer(ignoring: animation.isAnimating, child: child),
        child: widget.itemBuilder(
          context,
          item,
          CurvedAnimation(
            parent: animation,
            curve: forwardInterval,
            reverseCurve: reverseInterval,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => widget.viewBuilder(
        context,
        visibleItems.length,
        (context, index) => buildItem(
          visibleItems[index].item,
          visibleItems[index].controller,
        ),
      );
}
