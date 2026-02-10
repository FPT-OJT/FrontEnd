import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/profile/presentations/constants/data.dart';
import 'package:fpt_ojt/features/profile/presentations/models/action_item.dart';
import 'package:go_router/go_router.dart';

class ProfileAction extends StatelessWidget {
  const ProfileAction({super.key});

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(borderRadius: Rounded.sm),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: profileActionItems
          .map((item) => _buildActionItem(item, context))
          .toList(),
    ),
  );

  Widget _buildActionItem(ActionItem item, BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        context.push(item.routeName);
      },
      borderRadius: Rounded.sm,
      child: Container(
        width: double.infinity,
        height: UIGaps.size48,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            // Icon
            Padding(
              padding: const EdgeInsets.only(top: UIGaps.size12),
              child: Icon(item.icon, size: 24, color: AppColors.primaryForest),
            ),
            UIGaps.w16,
            // Label
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: UIGaps.size16),
                child: Text(
                  item.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryForest,
                  ),
                ),
              ),
            ),
            // Navigate arrow
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Icon(
                Icons.chevron_right,
                size: 24,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
