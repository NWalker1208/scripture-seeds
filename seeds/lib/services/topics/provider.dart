import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'index.dart';
import 'json.dart';

class TopicIndexProvider extends ChangeNotifier {
  final TopicIndexAssets _assetService;
  final TopicIndexWeb _webService;

  TopicIndex _index;
  TopicIndex get index => _index;

  TopicIndexProvider({AssetBundle assets})
      : _assetService = TopicIndexAssets(assets: assets),
        _webService = TopicIndexWeb() {
    _assetService.loadIndex().then((value) {
      _index = value;
      print('Loaded index with ${_index.topics.length} topics');
      notifyListeners();
    });

    // TODO: Load from web service as well
  }
}
