import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/card.dart'
    as card_entity;

class CardOption extends StatelessWidget {
  const CardOption({required this.card, this.isSelected = false, super.key});
  final card_entity.Card card;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final firstDeal = card.deals.firstOrNull;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UIGaps.size8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: UIGaps.size8,
        children: [
          // Icon
          Icon(
            Icons.check_circle,
            size: 20,
            color: isSelected
                ? AppColors.primaryCoin
                : AppColors.secondaryGreen,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.name,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryForest,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Select options',
                  style: AppTextStyles.bodyExtraSmall.copyWith(
                    color: AppColors.primaryForest.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

          // Right Section (Chỉ hiện nếu có data)
          if (firstDeal != null)
            Padding(
              padding: const EdgeInsets.only(top: UIGaps.size4),
              child: Row(
                spacing: UIGaps.size4, 
                children: [
                  Text(
                    '${firstDeal.discountRate}%',
                    style: AppTextStyles.bodyExtraSmall.copyWith(
                      color: AppColors.primaryForest,
                    ),
                  ),
                  Text(
                    '${firstDeal.cashbackRate}%',
                    style: AppTextStyles.bodyExtraSmall.copyWith(
                      color: AppColors.primaryForest,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
