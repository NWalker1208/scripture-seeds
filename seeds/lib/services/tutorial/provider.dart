import 'package:flutter/material.dart';

import '../../widgets/tutorial/focus.dart';
import '../provider.dart';
import 'database.dart';

class TutorialProvider extends ServiceProvider<TutorialDatabase> {
  TutorialProvider(TutorialDatabase Function() create) : super(create);

  Set<String> _tagsShown;

  /// Check if the given tutorial tag has been completed.
  bool operator [](String tag) => _tagsShown?.contains(tag) ?? false;

  /// Mark the given tutorial tag as having been completed or not.
  void operator []=(String tag, bool value) {
    if (!isLoaded) return;
    if (value && !this[tag]) _tagsShown.add(tag);
    if (!value && this[tag]) _tagsShown.remove(tag);
    notifyService((data) => data.save(tag, value));
  }

  /// Reset all tutorials.
  void reset() {
    _tagsShown.clear();
    notifyService((data) => data.clear());
  }

  /// Shows the tutorial for the given context. Completes once all overlays
  /// have been closed.
  Future<void> showTutorial(TutorialFocusState focus,
      {bool force = true}) {
    final tag = focus.widget.tag;

    // Check if this tutorial has already been completed.
    if (!force && (tag == null || this[tag])) return Future.value();
    if (tag != null) this[tag] = true;

    // Show the tutorial overlay
    return () async {
      await Scrollable.ensureVisible(focus.context, alignment: 0.5);
      await WidgetsBinding.instance.endOfFrame;
      await focus.showOverlay();
    }();
  }

  @override
  Future<void> loadData(TutorialDatabase data) async {
    final tutorials = await data.loadAll();
    _tagsShown = {
      for (var entry in tutorials.entries)
        if (entry.value) entry.key,
    };
  }
}
