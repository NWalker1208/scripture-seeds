import 'package:flutter/material.dart';

import 'service.dart';

const int _initialBalance = 3;

class WalletProvider extends ChangeNotifier {
  WalletProvider(WalletService service) : _service = service {
    _service.loadBalance().then((balance) {
      if (balance == null) {
        balance = _initialBalance;
        _service.setBalance(balance);
      }
      _balance = balance;
      notifyListeners();
    });
  }

  final WalletService _service;

  /// Check if the wallet has been loaded.
  bool get isLoaded => _balance != null;

  int _balance;

  /// Current balance of the wallet.
  int get balance => _balance ?? 0;

  /// Add the given amount to the wallet.
  void add(int amount) {
    print('Added $amount to wallet.');

    _balance += amount;
    _service.add(amount);
    notifyListeners();
  }

  /// Returns true if balance is greater than or equal to the price.
  bool canAfford(int price) => _balance >= price;

  /// Spend the given amount.
  /// Returns true if enough balance was available.
  /// Returns false and does not modify balance otherwise.
  bool spend(int amount) {
    if (_balance < amount) return false;

    print('Spent $amount from wallet.');

    _balance -= amount;
    _service.subtract(amount);
    notifyListeners();
    return true;
  }

  /// Reset balance to [_initialBalance].
  void reset() {
    _balance = _initialBalance;
    _service.setBalance(_initialBalance);
    notifyListeners();
  }

  @override
  void dispose() {
    _service.close();
    super.dispose();
  }
}
