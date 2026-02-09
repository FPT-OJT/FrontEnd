import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/home/domain/entities/product_deal.dart';

class FoodDealCard extends StatelessWidget {
  const FoodDealCard({required this.productDeal, super.key});

  final ProductDeal productDeal;

  // Size constants
  static const double cardWidth = 150;
  static const double cardHeight = 136;
  static const double imageHeight = 62;
  static const double discountBadgeSize = 32;
  static const double discountFontSize = 8;

  @override
  Widget build(BuildContext context) => Container(
    width: cardWidth,
    height: cardHeight,
    decoration: BoxDecoration(
      color: AppColors.neutralWhite,
      borderRadius: Rounded.lg,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageWithDiscount(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(UIGaps.size8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildProductName(), _buildPriceSection()],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildImageWithDiscount() => Stack(
    clipBehavior: Clip.none,
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Image.network(
          productDeal.imageUrl ?? '',
          height: imageHeight,
          width: cardWidth,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            height: imageHeight,
            width: cardWidth,
            color: AppColors.neutralGrey,
            child: const Icon(Icons.fastfood, color: AppColors.neutralWhite),
          ),
        ),
      ),
      Positioned(right: 8, bottom: -8, child: _buildDiscountBadge()),
    ],
  );

  Widget _buildDiscountBadge() => Container(
    width: discountBadgeSize,
    height: discountBadgeSize,
    decoration: BoxDecoration(
      color: AppColors.primaryCoin,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: AppColors.neutralBlack.withValues(alpha: 0.1),
          offset: const Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    ),
    child: Center(
      child: Text(
        '-${productDeal.discountPercentage?.toStringAsFixed(0)}%',
        style: const TextStyle(
          fontSize: discountFontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryForest,
        ),
      ),
    ),
  );

  Widget _buildProductName() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Seasoned123 coconut\nchicken bowl',
        style: AppTextStyles.bodyExtraSmall.copyWith(
          color: AppColors.primaryForest,
          fontWeight: FontWeight.w700,
        ),
      ),
      Text(
        'chicken bowl',
        style: AppTextStyles.bodyExtraSmall.copyWith(
          color: AppColors.primaryForest,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );

  Widget _buildPriceSection() => Row(
    children: [
      Text(
        '\$${productDeal.discountedPrice?.toStringAsFixed(2) ?? '0.00'}',
        style: AppTextStyles.bodyExtraSmall.copyWith(
          color: AppColors.secondaryCoral,
          fontWeight: FontWeight.w700,
        ),
      ),
      UIGaps.w4,
      Text(
        '\$${productDeal.originalPrice?.toStringAsFixed(2) ?? '0.00'}',
        style: AppTextStyles.bodyExtraSmall.copyWith(
          color: AppColors.secondaryNavy,
          decoration: TextDecoration.lineThrough,
        ),
      ),
    ],
  );
}
