import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/profile/presentations/constants/profile_update.dart';
import 'package:go_router/go_router.dart';

class EditProfileHeadSection extends StatelessWidget {
  const EditProfileHeadSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: UIGaps.size12),
    height: ProfileUpdateConstants.headerHeight,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: ProfileUpdateConstants.backButtonSize,
              height: ProfileUpdateConstants.backButtonSize,
              decoration: BoxDecoration(
                color: AppColors.neutralWhite.withValues(
                  alpha: ProfileUpdateConstants.backButtonOpacity,
                ),
                borderRadius: BorderRadius.circular(
                  ProfileUpdateConstants.backButtonRadius,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: ProfileUpdateConstants.backButtonIconSize,
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            Text(
              ProfileUpdateConstants.editProfileTitle,
              style: AppTextStyles.h2.copyWith(color: AppColors.neutralWhite),
            ),
          ],
        ),
        Image.asset(
          ProfileUpdateConstants.headerImagePath,
          height: ProfileUpdateConstants.headerImageHeight,
          width: ProfileUpdateConstants.headerImageWidth,
        ),
      ],
    ),
  );
}
