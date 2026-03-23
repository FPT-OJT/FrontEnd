import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.elevation,
    this.shadowColor,
    super.key,
  });

  final VoidCallback onPressed;
  final String text;
  final Widget icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: UIGaps.size48,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(borderRadius: Rounded.md),
        elevation: elevation,
        shadowColor: shadowColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          UIGaps.w12,
          Text(text, style: AppTextStyles.button),
        ],
      ),
    ),
  );
}
