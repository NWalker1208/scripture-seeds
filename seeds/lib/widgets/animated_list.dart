import 'package:flutter/widgets.dart';

class AnimatedListBuilder<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(
    BuildContext context,
    IndexedWidgetBuilder itemBuilder,
    int itemCount,
  ) viewBuilder;
  final Widget Function(
    BuildContext context,
    T item,
    Animation<double> animation,
  ) childBuilder;
  final Duration duration;

  AnimatedListBuilder({
    this.items = const [],
    @required this.viewBuilder,
    @required this.childBuilder,
    @required this.duration,
    Key key,
  }) : super(key: key);

  AnimatedListBuilder.list({
    this.items = const [],
    @required Widget Function(BuildContext, List<Widget>) viewBuilder,
    @required this.childBuilder,
    @required this.duration,
    Key key,
  })  : viewBuilder = ((context, itemBuilder, itemCount) => viewBuilder(
              context,
              List.generate(
                itemCount,
                (index) => itemBuilder(context, index),
              ),
            )),
        super(key: key);

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
  bool itemsChanged;
  List<_ItemController<T>> currentItems;

  // Updates current items based on the difference between oldItems and newItems
  void updateItemsList() {
    var newItems = <_ItemController<T>>[];
    var oldItems = <_ItemController<T>>[];

    for (var item in widget.items) {
      var keyPair = currentItems.firstWhere(
        (keyPair) => keyPair.item == item,
        orElse: () => null,
      );

      if (keyPair == null) {
        keyPair = _ItemController(
            item,
            AnimationController(
              vsync: this,
              duration: widget.duration,
            ));
        keyPair.controller.forward();
      } else {
        // Animate out any skipped items, then remove from list
        var index = currentItems.indexOf(keyPair);
        var skipped = currentItems.getRange(0, index);
        oldItems.addAll(skipped);
        newItems.addAll(skipped);
        currentItems.removeRange(0, index + 1);
      }

      newItems.add(keyPair);
    }

    // Add remaining items to old items list to animate out
    oldItems.addAll(currentItems);
    newItems.addAll(currentItems);

    currentItems = newItems;
    itemsChanged = true;

    for (var oldItem in oldItems) {
      oldItem.controller.reverse().then((value) => setState(() {
            oldItem.controller.dispose();
            return currentItems.remove(oldItem);
          }));
    }
  }

  @override
  void initState() {
    itemsChanged = false;
    currentItems = widget.items
        .map((item) => _ItemController(
            item,
            AnimationController(
              vsync: this,
              value: 1,
              duration: widget.duration,
            )))
        .toList();
    super.initState();
  }

  @override
  void dispose() {
    for (var item in currentItems) {
      item.controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedListBuilder<T> oldWidget) {
    updateItemsList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => widget.viewBuilder(
        context,
        (context, index) => widget.childBuilder(
          context,
          currentItems[index].item,
          currentItems[index].controller,
        ),
        currentItems.length,
      );
}
