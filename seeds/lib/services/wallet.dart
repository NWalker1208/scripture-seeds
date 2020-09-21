import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletData extends ChangeNotifier {
  static const String kWallet = 'wallet';

  int _funds;
  int get availableFunds => _funds;

  WalletData() {
    _funds = 0;

    // Get shared preferences
    SharedPreferences.getInstance().then((prefs) {
      _funds = prefs.getInt(kWallet) ?? 3;
      notifyListeners();
    });
  }

  void give(int funds) {
    _funds += funds;
    notifyListeners();
    _saveWallet();
  }

  bool spend(int funds) {
    if (_funds < funds)
      return false;

    _funds -= funds;
    notifyListeners();
    _saveWallet();
    return true;
  }

  void _saveWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(kWallet, _funds);
  }
}
