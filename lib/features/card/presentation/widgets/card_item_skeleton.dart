import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class CardItemSkeleton extends StatelessWidget {
  const CardItemSkeleton({super.key});

  static const double cardHeight = 48;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    height: cardHeight,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Shimmer.fromColors(
      baseColor: AppColors.neutralGrey,
      highlightColor: AppColors.neutralWhite,
      child: Row(
        children: [
          Container(
            width: 30,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.neutralWhite,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.neutralWhite,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
