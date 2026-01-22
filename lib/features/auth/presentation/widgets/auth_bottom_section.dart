import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/shared/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

const double logoHeight = 32;
const double logoWidth = 32;

class AuthBottomSection extends StatelessWidget {
  const AuthBottomSection({
    required this.promptText,
    required this.actionText,
    required this.routeName,
    super.key,
  });
  final String promptText;
  final String actionText;
  final String routeName;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: UIGaps.size8,
        children: [
          Text(promptText, style: AppTextStyles.bodyLarge),
          UIGaps.w4,
          GestureDetector(
            onTap: () => context.pushReplacement(routeName),
            child: Text(
              actionText,
              style: AppTextStyles.h3.copyWith(color: AppColors.secondaryCoral),
            ),
          ),
        ],
      ),
      UIGaps.h32,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppConstants.logoImage,
            height: logoHeight,
            width: logoWidth,
          ),
          UIGaps.w8,
          Text(
            AppConstants.appName,
            style: AppTextStyles.h2.copyWith(color: AppColors.neutralBlack),
          ),
        ],
      ),
      UIGaps.h24,
    ],
  );
}
