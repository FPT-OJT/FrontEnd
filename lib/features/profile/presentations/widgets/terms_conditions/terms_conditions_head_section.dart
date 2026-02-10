import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/profile/presentations/constants/terms_conditions.dart';
import 'package:go_router/go_router.dart';

class TermsConditionsHeadSection extends StatelessWidget {
  const TermsConditionsHeadSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: UIGaps.size12),
    height: TermsConditionsConstants.headerHeight,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: TermsConditionsConstants.backButtonSize,
          height: TermsConditionsConstants.backButtonSize,
          decoration: BoxDecoration(
            color: AppColors.neutralWhite.withValues(
              alpha: TermsConditionsConstants.backButtonOpacity,
            ),
            borderRadius: BorderRadius.circular(
              TermsConditionsConstants.backButtonRadius,
            ),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: TermsConditionsConstants.backButtonIconSize,
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        Text(
          TermsConditionsConstants.termsConditionsTitle,
          style: AppTextStyles.h2.copyWith(color: AppColors.neutralWhite),
        ),
      ],
    ),
  );
}
