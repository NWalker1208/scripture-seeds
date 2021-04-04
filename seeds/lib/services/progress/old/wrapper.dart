import '../database.dart';
import '../event.dart';
import 'database.dart';

class OldProgressWrapper
    extends ProgressEventDatabase<Map<DateTime, ProgressEvent>> {
  OldProgressWrapper(this.inner);

  final ProgressDatabase inner;

  @override
  Future<Map<DateTime, ProgressEvent>> open() async {
    var offset = 0; // Offset ensures events do not share the same dateTime
    final events = <ProgressEvent>[
      for (final record in await inner.loadAllRecords())
        ProgressEvent(
          record.topic,
          dateTime: record.lastUpdate ??
              DateTime.now().subtract(Duration(seconds: offset++)),
          value: record.lastProgress,
          reset: true,
        ),
    ];
    return {for (final event in events) event.dateTime: event};
  }

  @override
  Future<ProgressEvent> load(DateTime key) async => (await data)[key];

  @override
  Future<Iterable<DateTime>> loadKeys() async => (await data).keys;

  @override
  Future<bool> remove(DateTime key) async {
    final wrapped = await data;
    final success = await inner.remove(wrapped[key].topic);
    wrapped.remove(key);
    return success;
  }

  @override
  Future<void> delete() async {
    await inner.delete();
    await super.delete();
  }

  @override
  Future<void> save(DateTime key, ProgressEvent value) {
    throw UnimplementedError('Wrapper databases are read only.');
  }

  @override
  Future<void> close() async {
    if (inner.isOpen) await inner.close();
    await super.close();
  }
}
