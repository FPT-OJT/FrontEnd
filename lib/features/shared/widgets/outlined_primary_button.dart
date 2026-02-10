import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/borders.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/shadows.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';

class OutlinedPrimaryButton extends StatelessWidget {
  const OutlinedPrimaryButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  static const double borderWidth = 2;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: UIGaps.size48,
    child: OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.secondaryCoral,
        side: const BorderSide(
          color: AppColors.secondaryCoral,
          width: borderWidth,
        ),
        shape: RoundedRectangleBorder(borderRadius: Rounded.md),
        elevation: Shadows.none,
      ),
      child: isLoading
          ? const SizedBox(
              height: UIGaps.size20,
              width: UIGaps.size20,
              child: CircularProgressIndicator(
                strokeWidth: Borders.xs,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.secondaryCoral,
                ),
              ),
            )
          : Text(text, style: AppTextStyles.button),
    ),
  );
}
