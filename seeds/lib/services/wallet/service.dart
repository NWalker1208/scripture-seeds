import '../service.dart';

abstract class WalletService<S> extends CustomService<S> {
  /// Load the current balance.
  Future<int> loadBalance();

  /// Set the balance to the given amount.
  Future<void> setBalance(int amount);

  /// Subtract the given amount from the current balance.
  /// Returns the new balance.
  Future<int> subtract(int amount) async {
    var bal = await loadBalance() - amount;
    await setBalance(bal);
    return bal;
  }

  /// Add the given amount to the current balance.
  /// Returns the new balance.
  Future<int> add(int amount) async {
    var bal = await loadBalance() + amount;
    await setBalance(bal);
    return bal;
  }
}
