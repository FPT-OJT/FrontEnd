import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class AuthBottomSection extends StatelessWidget {

  const AuthBottomSection({
    required this.promptText, required this.actionText, required this.routeName, super.key,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              promptText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.secondaryNavy,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => context.push(routeName),
              child: Text(
                actionText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryCoral,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        // Minstant logo
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 32, width: 32),
            const SizedBox(width: 8),
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
      ],
    );
  }
}
