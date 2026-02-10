import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';

class ProfileHeadSection extends StatelessWidget {
  const ProfileHeadSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    height: 120,
    padding: const EdgeInsets.symmetric(horizontal: UIGaps.size20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              'Profile',
              style: AppTextStyles.h2.copyWith(color: AppColors.neutralWhite),
            ),
          ],
        ),
        Image.asset('assets/images/profile/head.png', height: 80, width: 100),
      ],
    ),
  );
}
