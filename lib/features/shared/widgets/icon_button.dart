import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    this.size = 36,
    this.iconSize = 20,
    this.onPressed,
    this.color,
    super.key,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: AppColors.neutralWhite.withValues(alpha: 0.2),
      borderRadius: Rounded.xs,
    ),
    child: IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(icon, color: color ?? Colors.white, size: iconSize),
      onPressed: onPressed,
    ),
  );
}
