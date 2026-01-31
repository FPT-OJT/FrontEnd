import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/shadows.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({required this.onPressed, required this.text, super.key});
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: UIGaps.size48,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryCoral,
        foregroundColor: AppColors.neutralWhite,
        shape: RoundedRectangleBorder(borderRadius: Rounded.md),
        elevation: Shadows.none,
      ),
      child: Text(text, style: AppTextStyles.button),
    ),
  );
}
