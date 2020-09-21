import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletData extends ChangeNotifier {
  static const String kWallet = 'wallet';
  static const int kInitialBalance = 3;

  int _funds;
  int get availableFunds => _funds;

  WalletData() {
    _funds = 0;

    // Get shared preferences
    SharedPreferences.getInstance().then((prefs) {
      _funds = prefs.getInt(kWallet) ?? kInitialBalance;
      notifyListeners();
    });
  }

  void give(int funds) {
    print('$funds added to wallet.');

    _funds += funds;
    notifyListeners();
    _saveWallet();
  }

  bool spend(int funds) {
    if (_funds < funds)
      return false;

    print('$funds spent from wallet.');

    _funds -= funds;
    notifyListeners();
    _saveWallet();
    return true;
  }

  void reset() {
    _funds = kInitialBalance;
    notifyListeners();
    _saveWallet();
  }

  void _saveWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(kWallet, _funds);
  }
}
