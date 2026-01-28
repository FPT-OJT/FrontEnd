import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';

class ExploreSection extends StatelessWidget {
  const ExploreSection({super.key});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIGaps.h48,
            Text(
              'Explore more',
              style: AppTextStyles.h2.copyWith(color: AppColors.neutralWhite),
            ),
            UIGaps.h32,
            Text(
              'Unlock Exclusive Discounts: Navigate Through Merchants for the Best Deals Around',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.neutralWhite,
              ),
            ),
          ],
        ),
      ),
      Positioned(
        right: 0,
        top: 50,
        child: Image.asset(
          'assets/images/home/home_explore.png',
          height: 120,
          width: 120,
        ),
      ),
    ],
  );
}
