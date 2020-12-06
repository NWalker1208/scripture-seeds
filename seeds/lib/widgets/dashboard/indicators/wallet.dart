import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/custom_icons.dart';
import 'package:seeds/services/data/wallet.dart';

class WalletIndicator extends StatelessWidget {
  const WalletIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer<WalletData>(builder: (context, wallet, child) => Text('${wallet.availableFunds}')),
        const SizedBox(width: 4),
        const Icon(CustomIcons.seeds),
      ],
    );
  }
}
