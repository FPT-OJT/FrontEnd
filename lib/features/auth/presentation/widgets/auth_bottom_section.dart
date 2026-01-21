import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:go_router/go_router.dart';

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Prompt and action link
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Text(promptText, style: AppTextStyles.bodyLarge),
            UIGaps.w4,
            GestureDetector(
              onTap: () => context.pushReplacement(routeName),
              child: Text(
                actionText,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.secondaryCoral,
                ),
              ),
            ),
          ],
        ),
        UIGaps.h32,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 32, width: 32),
            UIGaps.w8,
            Text(
              'Minstant',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.neutralBlack,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        UIGaps.h24,
      ],
    );
  }
}
