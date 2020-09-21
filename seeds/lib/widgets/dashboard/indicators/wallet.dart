import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/wallet.dart';

class WalletIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer<WalletData>(builder: (context, wallet, child) => Text('${wallet.availableFunds}')),
        SizedBox(width: 4),
        ImageIcon(AssetImage('assets/seeds_icon.ico')) // TODO: Replace with seed
      ],
    );
  }
}
