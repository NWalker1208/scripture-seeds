import 'package:flutter/material.dart';

import '../../widgets/tutorial/step.dart';
import '../provider.dart';
import 'database.dart';

class TutorialProvider extends ServiceProvider<TutorialDatabase> {
  TutorialProvider(TutorialDatabase Function() create) : super(create);

  Set<String> _tagsShown;

  /// Check if the given tutorial tag has been completed.
  bool operator [](String tag) => _tagsShown?.contains(tag) ?? true;

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

  /// Shows the tutorial for the given tag, using all tutorial widgets under
  /// the given context.
  Future<void> show(BuildContext context, [String tag]) async {
    for (var step in TutorialStep.of(context, tag)) {
      await step.onStart(context);
    }
  }

  /// Shows the tutorial if the given tag has not already been shown.
  void maybeShow(BuildContext context, String tag) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (this[tag]) return;
      this[tag] = true;
      show(context, tag);
    });
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
