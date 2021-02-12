import 'package:flutter/services.dart';

import 'index.dart';
import 'service.dart';

class AssetTopicIndexService extends TopicIndexService<AssetBundle> {
  AssetTopicIndexService({String languageCode = 'eng'}) : super(languageCode);

  @override
  Future<AssetBundle> open() async => rootBundle;

  @override
  Future<TopicIndex> loadIndex() async {
    final assets = await data;
    return parseIndexJson(await assets.loadString('assets/$filename'));
  }
}
