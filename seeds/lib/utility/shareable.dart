import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

mixin Shareable {
  String toShareString() => toString();

  Future<bool> shareAsString() async {
    print('Sharing $runtimeType...');
    try {
      await Share.share(toShareString(), subject: 'Scripture Seeds');
    } on FormatException catch(e) {
      print('FormatException thrown while sharing $runtimeType: $e');
      return false;
    } on PlatformException catch(e) {
      print('PlatformException thrown while sharing $runtimeType: $e');
      return false;
    }
    return true;
  }
}
