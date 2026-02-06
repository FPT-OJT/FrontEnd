import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/home/presentation/constants/text.dart';

class ExploreSection extends StatelessWidget {
  const ExploreSection({super.key});
  static const exploreImage = 'assets/images/home/home_explore.png';
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
              HomeText.exploreMore,
              style: AppTextStyles.h2.copyWith(color: AppColors.neutralWhite),
            ),
            UIGaps.h32,
            Text(
              HomeText.exploreMoreDescription,
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
        child: Image.asset(exploreImage, height: 120, width: 120),
      ),
    ],
  );
}
