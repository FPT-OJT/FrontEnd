import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:go_router/go_router.dart';

class EditProfileHeadSection extends StatelessWidget {
  const EditProfileHeadSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: UIGaps.size12),
    height: 120,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.neutralWhite.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            Text(
              'Edit profile info',
              style: AppTextStyles.h2.copyWith(color: AppColors.neutralWhite),
            ),
          ],
        ),
        Image.asset('assets/images/profile/head.png', height: 80, width: 100),
      ],
    ),
  );
}
