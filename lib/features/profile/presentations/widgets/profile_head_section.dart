import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/profile/presentations/constants/profile_tab.dart';

class ProfileHeadSection extends StatelessWidget {
  const ProfileHeadSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    height: ProfileTabConstants.headerHeight,
    padding: const EdgeInsets.symmetric(horizontal: UIGaps.size20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              ProfileTabConstants.profileTitle,
              style: AppTextStyles.h2.copyWith(color: AppColors.neutralWhite),
            ),
          ],
        ),
        Image.asset(
          ProfileTabConstants.headerImagePath,
          height: ProfileTabConstants.headerImageHeight,
          width: ProfileTabConstants.headerImageWidth,
        ),
      ],
    ),
  );
}
