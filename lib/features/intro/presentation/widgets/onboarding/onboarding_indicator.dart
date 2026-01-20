import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    required this.itemCount,
    required this.activeIndex,
    super.key,
  });
  final int itemCount;
  final int activeIndex;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(itemCount, (index) {
      final isActive = index == activeIndex;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Icon(
          Icons.circle,
          size: 8,
          color: isActive
              ? AppColors.primaryForest
              : AppColors.primaryForest.withAlpha(128),
        ),
      );
    }),
  );
}
