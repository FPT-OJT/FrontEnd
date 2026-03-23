import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';

class SettingWarningItem extends StatelessWidget {
  const SettingWarningItem({
    required this.warningText,
    this.onClose,
    super.key,
  });
  final String warningText;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(color: AppColors.neutralWhite),
    child: Stack(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          leading: const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.primaryForest,
            size: 24,
          ),
          title: Text(
            warningText,
            style: AppTextStyles.bodyExtraSmall.copyWith(
              color: AppColors.primaryForest,
            ),
          ),
        ),
        if (onClose != null)
          Positioned(
            top: 7,
            right: 7,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                padding: const EdgeInsets.all(2),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.primaryForest,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
