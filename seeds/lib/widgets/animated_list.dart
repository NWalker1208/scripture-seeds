import 'package:flutter/widgets.dart';

class AnimatedListBuilder<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext, List<Widget>) viewBuilder;
  final Widget Function(BuildContext, T, Animation<double>) childBuilder;
  final Duration duration;

  AnimatedListBuilder({
    this.items = const [],
    @required this.viewBuilder,
    @required this.childBuilder,
    @required this.duration,
    Key key,
  }) : super(key: key);

  @override
  _AnimatedListBuilderState<T> createState() => _AnimatedListBuilderState();
}

class _ItemKeyPair<T, S extends State<StatefulWidget>> {
  T item;
  GlobalKey<S> key;

  _ItemKeyPair(this.item, [GlobalKey<S> key]) : this.key = key ?? GlobalKey();
}

class _AnimatedListBuilderState<T> extends State<AnimatedListBuilder<T>> {
  bool itemsChanged;
  List<_ItemKeyPair<T, _AnimatedListChildState>> currentItems;

  // Updates current items based on the difference between oldItems and newItems
  void updateItemsList() {
    List<_ItemKeyPair<T, _AnimatedListChildState>> newItems = [];
    List<_ItemKeyPair<T, _AnimatedListChildState>> oldItems = [];

    widget.items.forEach((item) {
      _ItemKeyPair<T, _AnimatedListChildState> keyPair =
          currentItems.firstWhere(
        (keyPair) => keyPair.item == item,
        orElse: () => null,
      );

      if (keyPair == null)
        keyPair = _ItemKeyPair(item);
      else {
        // Animate out any skipped items, then remove from list
        int index = currentItems.indexOf(keyPair);
        var skipped = currentItems.getRange(0, index);
        oldItems.addAll(skipped);
        newItems.addAll(skipped);
        currentItems.removeRange(0, index + 1);
      }

      newItems.add(keyPair);
    });

    // Add remaining items to old items list to animate out
    oldItems.addAll(currentItems);
    newItems.addAll(currentItems);

    currentItems = newItems;
    itemsChanged = true;

    oldItems.forEach((oldItem) => oldItem.key.currentState
        .animateOut()
        .then((value) => setState(() => currentItems.remove(oldItem))));
  }

  @override
  void initState() {
    itemsChanged = false;
    currentItems = widget.items
        .map((item) => _ItemKeyPair<T, _AnimatedListChildState>(item))
        .toList();
    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedListBuilder<T> oldWidget) {
    updateItemsList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.viewBuilder(
      context,
      currentItems
          .map((item) => _AnimatedListChild(
                item.item,
                builder: widget.childBuilder,
                duration: widget.duration,
                startVisible: !itemsChanged,
                key: item.key,
              ))
          .toList(),
    );
  }
}

class _AnimatedListChild<T> extends StatefulWidget {
  final T value;
  final Widget Function(BuildContext, T, Animation<double>) builder;
  final Duration duration;
  final bool startVisible;

  _AnimatedListChild(
    this.value, {
    @required this.builder,
    @required this.duration,
    this.startVisible = false,
    Key key,
  }) : super(key: key);

  @override
  _AnimatedListChildState createState() => _AnimatedListChildState();
}

class _AnimatedListChildState extends State<_AnimatedListChild>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  // Start fade out animation
  Future<void> animateOut() => _controller.reverse().orCancel;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.startVisible)
      _controller.value = 1;
    else
      _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedListChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      widget.value,
      _controller
    );
  }
}
