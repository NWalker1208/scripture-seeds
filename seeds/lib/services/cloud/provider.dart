import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../journal/entry.dart';
import '../journal/provider.dart';
import '../progress/provider.dart';
import '../progress/record.dart';
import 'service.dart';
import 'path.dart';

/// Manages the synchronization of local user data and the cloud.
class CloudProvider extends ChangeNotifier {
  /// Create the provider. If storage is not yet ready, do not pass a storage
  /// object. Syncing will throw exceptions until storage is ready.
  CloudProvider([CloudService storage]) : _storage = storage;

  DateTime _lastSync;
  CloudService _storage;

  /// True if the provider has finished loading data from the service.
  bool get ready => _storage != null;

  /// The time that the user's data was last synced with the cloud.
  DateTime get lastSync => _lastSync;

  /// Replace the current cloud storage with a new instance.
  void update(CloudService storage) {
    if (_storage == storage) return;
    _storage = storage;
    notifyListeners();
  }

  /// Erases progress in the cloud and creates a file to notify other clients
  /// that the progress has been reset.
  Future<void> reset() async {

  }

  /// Synchronize local data with the cloud.
  Future<void> sync(BuildContext context) async {
    if (!ready) throw Exception('Failed to sync, cloud storage is not ready.');

    // Sync user data
    await _syncProgress(Provider.of<ProgressProvider>(context, listen: false));
    //await _syncJournal(Provider.of<JournalProvider>(context, listen: false));

    // Notify listeners
    _lastSync = DateTime.now();
    notifyListeners();
  }

  static const _resetFilename = 'reset.txt';
  Future<DateTime> _lastReset() async {
    final file = await _storage.find(_resetFilename);
    if (file == null) return null;
    return DateTime.parse(await _storage.download(file));
  }

  static const _progressFilename = 'progress.json';
  Future<void> _syncProgress(ProgressProvider progress) async {
    final data = <String, ProgressRecord>{};

    // Download remote
    var file = await _storage.find(_progressFilename);

    if (file != null) {
      try {
        final online = jsonDecode(await _storage.download(file)) as List;
        for (var item in online) {
          if (item is Map<String, dynamic>) {
            final record = ProgressRecord.fromMap(item);
            data[record.id] = record;
          }
        }
      } on FormatException catch (e) {
        print('Failed to parse online progress: $e');
      }
    }
// TODO: Save new records not present in local records
    // Merge data
    var newerOnline = data.length;
    var newerLocal = 0;
    for (var record in progress.records) {
      if (data.containsKey(record.id)) {
        final existing = data[record.id];
        // If online is newer, save it locally
        if (record.lastUpdate == existing.lastUpdate) {
          newerOnline--;
          continue;
        } else if (record.lastUpdate == null ||
            (existing.lastUpdate != null &&
                existing.lastUpdate.isAfter(record.lastUpdate))) {
          progress.create(existing);
          continue;
        }
      }
      data[record.id] = record;
      newerOnline--;
      newerLocal++;
    }
    if (newerOnline == 0) {
      print('No new progress in cloud.');
    } else {
      print('Synced $newerOnline records that were newer in cloud.');
    }

    if (newerLocal == 0) {
      print('No local progress to sync.');
      return;
    }

    // Upload merged data
    file ??= await _storage.create(_progressFilename);
    assert(file != null);
    await _storage.upload(
      file,
      jsonEncode([for (final record in data.values) record.toMap()]),
    );
    print('Uploaded $newerLocal progress records to cloud.');
  }

  static const _journalDirectory = 'journal';
  Future<void> _syncJournal(JournalProvider journal) async {
    throw UnimplementedError();
    final data = <DateTime, JournalEntry>{};

    // Download remote
    var journalFolder = await _storage.find(_journalDirectory);

    if (journalFolder != null) {
      final online = await _storage.childrenOf(journalFolder);
    }

    // Merge data

    // Upload merged data
    journalFolder ??= await _storage.create(_journalDirectory, isFolder: true);
    assert(journalFolder != null);
  }
}
