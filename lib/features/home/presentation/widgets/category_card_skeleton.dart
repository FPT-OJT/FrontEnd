import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:shimmer/shimmer.dart';

class CategoryCardSkeleton extends StatelessWidget {
  const CategoryCardSkeleton({super.key, this.width = 100});

  final double width;
  static const double categoryCardHeight = 36;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: AppColors.neutralGrey,
    highlightColor: AppColors.neutralWhite,
    child: Container(
      height: categoryCardHeight,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: Rounded.xs,
      ),
    ),
  );
}
