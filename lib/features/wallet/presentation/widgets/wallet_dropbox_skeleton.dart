import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/features/wallet/presentation/widgets/wallet_item_skeleton.dart';

class WalletDropboxSkeleton extends StatelessWidget {
  const WalletDropboxSkeleton({super.key, this.isCard = false});

  final bool isCard;

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Colors.transparent,
      border: Border(bottom: BorderSide(color: AppColors.primaryForest)),
    ),
    padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(3, (_) => WalletItemSkeleton(isCard: isCard)),
    ),
  );
}
