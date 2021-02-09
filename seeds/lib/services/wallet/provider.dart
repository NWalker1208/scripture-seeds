import '../provider.dart';
import 'service.dart';

const int _initialBalance = 3;

class WalletProvider extends ServiceProvider<WalletService> {
  WalletProvider(WalletService Function() create) : super(create);

  int _balance;

  /// Current balance of the wallet.
  int get balance => _balance ?? 0;

  /// Returns true if balance is greater than or equal to the price.
  bool canAfford(int price) => _balance >= price;

  /// Add the given amount to the wallet.
  void add(int amount) {
    print('Added $amount to wallet.');

    _balance += amount;
    notifyService((s) => s.add(amount));
  }

  /// Spend the given amount.
  /// Returns true if enough balance was available.
  /// Returns false and does not modify balance otherwise.
  bool spend(int amount) {
    if (_balance < amount) return false;

    print('Spent $amount from wallet.');

    _balance -= amount;
    notifyService((s) => s.subtract(amount));
    return true;
  }

  /// Reset balance to [_initialBalance].
  void reset() {
    _balance = _initialBalance;
    notifyService((s) => s.setBalance(_initialBalance));
  }

  @override
  Future<void> loadData(WalletService service) async {
    _balance = await service.loadBalance();

    if (_balance == null) {
      _balance = _initialBalance;
      await service.setBalance(_balance);
    }
  }
}
