import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'index.dart';
import 'json.dart';

class TopicIndexProvider extends ChangeNotifier {
  final int daysBetweenRefreshes;
  final TopicIndexAssets _assetService;
  final TopicIndexWeb _webService;

  TopicIndex _index;
  TopicIndex get index => _index;

  DateTime _lastRefresh;
  DateTime get lastRefresh => _lastRefresh;

  TopicIndexProvider({this.daysBetweenRefreshes = 7, AssetBundle assets})
      : _assetService = TopicIndexAssets(assets: assets),
        _webService = TopicIndexWeb() {
    var indices = [_assetService.loadIndex(), _webService.loadIndex()];
    Future.wait(indices).then((indices) async {
      var assetIndex = indices[0];
      var webIndex = indices[1];

      // Check if web index is outdated
      if (webIndex == null || assetIndex.version > webIndex.version) {
        _index = assetIndex;
      } else {
        _index = webIndex;
      }

      if (_index == null) throw Exception('Unable to load any topic index!');

      // Load last refresh data
      _lastRefresh = await _webService.lastRefresh();

      print('Loaded index version ${_index.version} '
          'with ${_index.topics.length} topics');
      notifyListeners();

      // Check if should refresh
      if (_lastRefresh == null ||
          DateTime.now().difference(_lastRefresh).inDays >=
              daysBetweenRefreshes) {
        await refresh();
      }
    });
  }

  Future<bool> refresh() async {
    if (await _webService.refresh()) {
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
}
