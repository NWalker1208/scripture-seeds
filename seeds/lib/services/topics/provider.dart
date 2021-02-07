import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'index.dart';
import 'json.dart';
import 'web.dart';

class TopicIndexProvider extends ChangeNotifier {
  TopicIndexProvider({this.maxCacheAgeDays = 7, AssetBundle assets})
      : _assetService = TopicIndexAssets(assets: assets),
        _webService = TopicIndexWeb() {
    _initialize();
  }

  final int maxCacheAgeDays;
  final TopicIndexAssets _assetService;
  final TopicIndexWeb _webService;

  TopicIndex _index;
  TopicIndex get index => _index;

  DateTime _lastRefresh;
  DateTime get lastRefresh => _lastRefresh;

  /// Refresh the cached topic index download. Returns true if successful.
  /// Does nothing when running from web.
  Future<bool> refresh() async {
    if (!kIsWeb && await _webService.refresh()) {
      var newIndex = await _webService.loadIndex();

      if (newIndex != null) {
        _index = newIndex;
        _lastRefresh = DateTime.now();
        notifyListeners();
        return true;
      }
    }

    return false;
  }

  /// Loads the index from assets, and web if possible.
  Future<void> _initialize() async {
    _index = await _assetService.loadIndex();

    // Will not run when kIsWeb is true. _webService will be null.
    if (!kIsWeb) {
      final webIndex = await _webService.loadIndex();
      if (webIndex != null &&
          (_index == null || _index.version < webIndex.version)) {
        _index = webIndex;
      }
    }

    if (_index == null) throw Exception('Unable to load any topic index!');
    print('Loaded index version ${_index.version} with'
        ' ${_index.topics.length} topics.');

    _lastRefresh = kIsWeb ? DateTime.now() : await _webService.lastRefresh();
    notifyListeners();

    // Check if should refresh
    if (_lastRefresh == null ||
        DateTime.now().difference(_lastRefresh).inDays >= maxCacheAgeDays) {
      await refresh();
    }
  }
}
