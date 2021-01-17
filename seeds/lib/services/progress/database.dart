import 'dart:core';

import 'record.dart';

abstract class ProgressDatabase {
  Future<Iterable<String>> getRecordNames();
  Future<ProgressRecord> loadRecord(String name);
  Future<void> saveRecord(ProgressRecord record);
  Future<bool> deleteRecord(String name);
  Future<void> deleteAllRecords();
  Future<void> close() async {}

  Future<Iterable<ProgressRecord>> loadAllRecords() async => [
        for (var name in await getRecordNames()) await loadRecord(name),
      ];
}
