import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/custom_icons.dart';
import '../../../services/data/wallet.dart';

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
          Consumer<WalletData>(
            builder: (context, wallet, child) => Text('${wallet.availableFunds}'
                '${required == null ? '' : '/$required'}'),
          ),
          const SizedBox(width: 4),
          const Icon(CustomIcons.seeds),
        ],
      );
}
