import 'package:flutter/material.dart';
import 'package:kitchenowl/kitchenowl.dart';
import 'package:kitchenowl/models/token.dart';
import 'package:kitchenowl/widgets/settings/token_card.dart';

class TokenBottomSheet extends StatelessWidget {
  final Token token;
  final void Function()? onLogout;

  const TokenBottomSheet({super.key, required this.token, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TokenCard(
              token: token,
              enableOnTap: false,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: onLogout,
              child: Text(
                AppLocalizations.of(context)!.logoutName(token.name),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
