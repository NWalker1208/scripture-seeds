import 'package:shared_preferences/shared_preferences.dart';

import 'service.dart';

const String _walletPref = 'wallet';

class SharedPrefsWalletService extends WalletService<SharedPreferences> {
  @override
  Future<SharedPreferences> open() => SharedPreferences.getInstance();

  @override
  Future<int> loadBalance() async {
    final prefs = await data;
    return prefs.getInt(_walletPref);
  }

  @override
  Future<void> setBalance(int amount) async {
    final prefs = await data;
    await prefs.setInt(_walletPref, amount);
  }
}
