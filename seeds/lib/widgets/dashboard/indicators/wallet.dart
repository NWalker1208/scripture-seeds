import 'package:flutter/material.dart';

class WalletIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('0'), // TODO: Read value from wallet
        SizedBox(width: 4),
        ImageIcon(AssetImage('assets/seeds_icon.ico')) // TODO: Replace with seed
      ],
    );
  }
}
