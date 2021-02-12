import 'package:flutter/foundation.dart';

import 'assets.dart';
import 'index.dart';
import 'web.dart';

class TopicIndexProvider extends ChangeNotifier {
  TopicIndexProvider({this.maxCacheAgeDays = 7})
      : _assetService = AssetTopicIndexService(),
        _webService = WebTopicIndexService() {
    _initialize();
  }

  final int maxCacheAgeDays;
  final AssetTopicIndexService _assetService;
  final WebTopicIndexService _webService;

  TopicIndex _index;
  TopicIndex get index => _index;

  DateTime _lastRefresh;
  DateTime get lastRefresh => _lastRefresh;

  /// Refresh the cached topic index download. Returns true if successful.
  /// Does nothing when running from web.
  Future<bool> refresh() async {
    var newIndex = await _webService.refresh();
    if (newIndex != null && _index.version <= newIndex.version) {
      _index = newIndex;
      _lastRefresh = DateTime.now();
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Loads the index from assets, and web if possible.
  Future<void> _initialize() async {
    _index = await _assetService.loadIndex();

    // Try downloading the index from the web server
    final webIndex = await _webService.loadIndex();
    if (webIndex != null &&
        (_index == null || _index.version < webIndex.version)) {
      _index = webIndex;
    }

    if (_index == null) throw Exception('Unable to load any topic index!');
    _lastRefresh =
        kIsWeb ? DateTime.now() : await _webService.cacheLastModified;
    notifyListeners();

    // Check if should refresh
    if (_lastRefresh == null ||
        DateTime.now().difference(_lastRefresh).inDays >= maxCacheAgeDays) {
      await refresh();
    }
  }
}
