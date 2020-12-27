import 'package:flutter/widgets.dart';

import '../extensions/list.dart';

typedef IndexedViewBuilder = Widget Function(
  BuildContext context,
  IndexedWidgetBuilder itemBuilder,
  int itemCount,
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
    (context, itemBuilder, itemCount) => viewBuilder(context,
        List.generate(itemCount, (index) => itemBuilder(context, index)));

class AnimatedListBuilder<T> extends StatefulWidget {
  final Iterable<T> values;
  final IndexedViewBuilder viewBuilder;
  final AnimatedItemBuilder<T> childBuilder;
  final Duration duration;
  final Duration insertDelay;
  final Duration removeDelay;

  AnimatedListBuilder({
    this.values = const [],
    @required this.viewBuilder,
    @required this.childBuilder,
    @required this.duration,
    this.insertDelay = const Duration(),
    this.removeDelay = const Duration(),
    Key key,
  }) : super(key: key);

  AnimatedListBuilder.list({
    this.values = const [],
    @required ListViewBuilder viewBuilder,
    @required this.childBuilder,
    @required this.duration,
    this.insertDelay = const Duration(),
    this.removeDelay = const Duration(),
    Key key,
  })  : viewBuilder = _listToIndexedViewBuilder(viewBuilder),
        super(key: key);

  @override
  _AnimatedListBuilderState<T> createState() => _AnimatedListBuilderState<T>();
}

class _ItemController<T> {
  T value;
  bool changing;
  AnimationController controller;

  _ItemController(this.value, this.controller, [this.changing = false]);
}

class _AnimatedListBuilderState<T> extends State<AnimatedListBuilder<T>>
    with TickerProviderStateMixin {
  List<_ItemController<T>> visibleItems;

  // Updates current items based on the difference between oldItems and newItems
  void updateItemList() {
    var comparison = visibleItems.compareTo<T>(
      widget.values,
      compare: (controller, item) => controller.value == item,
      convert: (item) => _ItemController(
          item, AnimationController(vsync: this, duration: widget.duration)),
    );

    setState(() {
      visibleItems = comparison.merged;

      // Start animations for removed items
      for (var oldItem in comparison.oldItems) {
        oldItem.changing = true;
        Future.delayed(
          widget.removeDelay,
          () => oldItem.controller?.reverse()?.then((_) => setState(() {
                oldItem.controller?.dispose();
                oldItem.controller = null;
                visibleItems.remove(oldItem);
              })),
        );
      }

      // Start animations for added items
      for (var newItem in comparison.newItems) {
        newItem.changing = true;
        Future.delayed(
          widget.insertDelay,
          () => newItem.controller
              .forward()
              .then((_) => setState(() => newItem.changing = false)),
        );
      }
    });
  }

  @override
  void initState() {
    visibleItems = widget.values
        .map((value) => _ItemController(
              value,
              AnimationController(
                  vsync: this, value: 1, duration: widget.duration),
            ))
        .toList();
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
    updateItemList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => widget.viewBuilder(
        context,
        (context, index) => IgnorePointer(
          key: ValueKey(visibleItems[index].value),
          ignoring: visibleItems[index].changing,
          child: widget.childBuilder(
            context,
            visibleItems[index].value,
            visibleItems[index].controller,
          ),
        ),
        visibleItems.length,
      );
}
