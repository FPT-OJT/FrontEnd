import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/app_theme.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    required this.id,
    required this.cardName,
    this.imageUrl,
    super.key,
    this.onTap,
  });
  final String cardName;
  final String? imageUrl;
  final String id;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: AppTheme.cardShadows(),
      ),
      child: Row(
        children: [
          if (imageUrl != null && imageUrl!.isNotEmpty)
            Image.network(
              imageUrl!,
              width: 30,
              height: 24,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 30,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primaryForest.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.credit_card,
                  size: 16,
                  color: AppColors.primaryForest,
                ),
              ),
            )
          else
            Container(
              width: 30,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primaryForest.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.credit_card,
                size: 16,
                color: AppColors.primaryForest,
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              cardName,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primaryForest,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    ),
  );
}
