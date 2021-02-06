import 'package:flutter/material.dart';

import '../../widgets/tutorial/focus.dart';
import 'database.dart';

class TutorialProvider extends ChangeNotifier {
  TutorialProvider(this.database) {
    database.loadAll().then((tutorials) {
      _tagsShown
          .addAll(tutorials.entries.where((e) => e.value).map((e) => e.key));
      notifyListeners();
    });
  }

  final TutorialDatabase database;
  final _tagsShown = <String>{};

  /// Check if the given tutorial tag has been completed.
  bool _completed(String tag) => _tagsShown?.contains(tag) ?? false;

  /// Mark the given tutorial tag as having been shown.
  void markCompleted(String tag) {
    if (_tagsShown.contains(tag)) return;
    _tagsShown.add(tag);
    notifyListeners();
    database.save(tag, true);
  }

  /// Reset all tutorials
  void reset() {
    _tagsShown.clear();
    notifyListeners();
    database.clear();
  }

  /// Shows the tutorial for the given context. Completes once all overlays
  /// have been closed.
  Future<void> showTutorial(BuildContext context, {bool force = true}) async {
    final widgets = TutorialFocus.allIn(context);
    for (var focus in widgets) {
      final tag = focus.widget.tag;

      // Check if this tutorial has already been completed.
      if (!force &&
          (tag == null || _completed(tag) || await database.load(tag))) {
        continue;
      }

      // Show the tutorial overlay
      await Scrollable.ensureVisible(focus.context, alignment: 0.5);
      await WidgetsBinding.instance.endOfFrame;
      await focus.showOverlay();
      if (tag != null) markCompleted(tag);
    }
  }
}
