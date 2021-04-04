import 'dart:collection';

import '../progress/record.dart';

import 'event.dart';

/// Processes progress events to create a set of progress records.
class ProgressLedger {
  ProgressLedger([Iterable<ProgressEvent> events]) {
    if (events != null) addAll(events);
  }

  final SplayTreeSet<ProgressEvent> _events = SplayTreeSet();
  Map<String, ProgressRecord> _stateCache;
  Map<String, ProgressRecord> get _state => _stateCache ??= _processState();

  /// A list of all necessary events in the order that they occurred.
  Iterable<ProgressEvent> get compressedEvents => _events;

  /// Gets the topics of all progress records.
  Iterable<String> get topics => _state.keys;

  /// Gets the progress record for a given topic. Null if not present.
  ProgressRecord operator [](String topic) => _state[topic];

  /// Adds the event to the current history.
  void add(ProgressEvent event) {
    _events.add(event);
    _compressEvents();
    _stateCache = null;
  }

  /// Adds the list of events to the current history.
  void addAll(Iterable<ProgressEvent> events) {
    _events.addAll(events);
    _compressEvents();
    _stateCache = null;
  }

  /// Compress the list of events by removing unnecessary entries.
  /// i.e. Events followed by others setting the progress of the same topic.
  void _compressEvents() {
    final topicMap = <String, List<ProgressEvent>>{};
    // Prune all events that occur prior to a value reset.
    final remove = <ProgressEvent>[];
    for (final event in _events) {
      topicMap[event.topic] ??= [];
      final topicEvents = topicMap[event.topic];
      // If event resets progress, remove prior events for topic.
      if (event.reset) {
        remove.addAll(topicEvents);
        topicEvents.clear();
      }
      // Add this event to the list for topic
      topicMap[event.topic].add(event);
    }
    // Remove the pruned events.
    _events.removeAll(remove);
  }

  /// Process the list of events into progress records.
  Map<String, ProgressRecord> _processState() {
    final records = <String, ProgressRecord>{};
    for (final event in _events) {
      final old = records[event.topic];
      // TODO: Account for progress lost
      final progress = (event.reset ? 0 : old?.progress ?? 0) + event.value;
      // If progress increased with this event, the lastUpdate of this topic
      // will be set to the dateTime of this event.
      final update =
          progress > (old?.progress ?? 0) ? event.dateTime : old?.lastUpdate;
      // If progress has fallen below zero, don't create a progress record.
      if (progress < 0) {
        records.remove(event.topic);
      } else {
        records[event.topic] = ProgressRecord(
          event.topic,
          lastUpdate: update,
          lastProgress: progress,
        );
      }
    }
    return records;
  }
}
