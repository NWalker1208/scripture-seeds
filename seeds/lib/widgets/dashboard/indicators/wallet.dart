import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/wallet/provider.dart';
import '../../../utility/custom_icons.dart';

class WalletIndicator extends StatelessWidget {
  final int required;

  const WalletIndicator({
    this.required,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<WalletProvider>(
            builder: (context, wallet, child) => Text('${wallet.balance}'
                '${required == null ? '' : '/$required'}'),
          ),
          const SizedBox(width: 4),
          const Icon(CustomIcons.seeds),
        ],
      );
}
