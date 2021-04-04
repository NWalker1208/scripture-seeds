import '../provider.dart';
import 'database.dart';
import 'event.dart';
import 'ledger.dart';
import 'record.dart';

const _rewardAmount = 2;

class ProgressProvider extends ServiceProvider<ProgressEventDatabase> {
  ProgressProvider(ProgressEventDatabase Function() create) : super(create);

  final ProgressLedger _ledger = ProgressLedger();

  /// The list of all relevant events.
  Iterable<ProgressEvent> get events => _ledger.compressedEvents;

  /// The list of topics stored in the ledger.
  Iterable<String> get topics => _ledger.topics;

  /// Gets the current progress record for the topic.
  ProgressRecord operator [](String topic) => _ledger[topic];

  /// Creates a progress record for the topic if it doesn't exist.
  void create(String topic) {
    if (!topics.contains(topic)) set(topic, 0);
  }

  /// Adds progress to the topic.
  void add(String topic, [int value = 1]) =>
      _addEvent(ProgressEvent(topic, value: value));

  /// Sets the progress for the topic.
  void set(String topic, [int value = 0]) =>
      _addEvent(ProgressEvent(topic, value: value, reset: true));

  /// Collects a reward from the topic, if available. Returns the amount
  /// rewarded (currently the constant [_rewardAmount]).
  /// If no reward is available, returns zero.
  int collectReward(String topic) {
    if (_ledger[topic]?.hasReward == true) {
      set(topic, 0);
      return _rewardAmount;
    }
    return 0;
  }

  /// Removes the progress record for a topic. Returns true if one was present.
  bool remove(String topic) {
    if (!topics.contains(topic)) return false;
    _addEvent(ProgressEvent.remove(topic));
    return true;
  }

  /// Resets progress for all topics.
  void reset() => _addEvents([
        for (var topic in topics) ProgressEvent.remove(topic),
      ]);

  /// Adds an event to the internal ledger.
  void _addEvent(ProgressEvent event) {
    _ledger.add(event);
    notifyService((data) => data.saveEvent(event));
  }

  /// Adds an event to the internal ledger.
  void _addEvents(Iterable<ProgressEvent> events) {
    _ledger.addAll(events);
    notifyService((data) async {
      for (var event in events) {
        await data.saveEvent(event);
      }
    });
  }

  @override
  Future<void> loadData(ProgressEventDatabase data) async {
    _ledger.addAll(await data.loadAllEvents());
  }
}
