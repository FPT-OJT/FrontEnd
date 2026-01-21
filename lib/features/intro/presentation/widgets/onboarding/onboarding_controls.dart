import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/features/intro/presentation/constants/onboarding_constants.dart';

class OnboardingControls extends StatelessWidget {
  const OnboardingControls({
    required this.showButton,
    super.key,
    this.onGetStarted,
  });
  final bool showButton;
  final VoidCallback? onGetStarted;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 48,
    child: showButton
        ? ElevatedButton(
            onPressed: onGetStarted,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryCoral,
              foregroundColor: AppColors.neutralWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(OnboardingConstants.getStartedButtonText),
          )
        : const SizedBox.shrink(),
  );
}
