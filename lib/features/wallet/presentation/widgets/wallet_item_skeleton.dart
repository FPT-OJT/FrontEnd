import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class WalletItemSkeleton extends StatelessWidget {
  const WalletItemSkeleton({super.key, this.isCard = false});

  final bool isCard;

  static const double otherItemSize = 83;
  static const double cardItemHeight = 85;
  static const double cardItemWidth = 131;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: AppColors.neutralGrey,
    highlightColor: AppColors.neutralWhite,
    child: Container(
      width: isCard ? cardItemWidth : otherItemSize,
      height: isCard ? cardItemHeight : otherItemSize,
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
