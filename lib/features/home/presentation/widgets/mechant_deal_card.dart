import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';
import 'package:shimmer/shimmer.dart';

class MerchantDealCard extends StatelessWidget {
  const MerchantDealCard({
    required this.merchantAgency,
    required this.currentLocation,
    super.key,
  });

  final MerchantAgency merchantAgency;
  final Coordinate currentLocation;

  // Distance constants
  static const double meterPerKiloMeter = 1000;

  // Size constants
  static const double cardHeight = 72;
  static const double iconSize = 40;
  static const double actionIconSize = 22;
  static const double dealRateContainerHeight = 24;
  static const double errorIconSize = 24;

  // Spacing constants
  static const double logoToInfoSpacing = 12;
  static const double nameToDescriptionSpacing = 4;
  static const double infoToActionsSpacing = 8;
  static const double logoPadding = 2;

  // Typography constants
  static const double dealRateFontSize = 6;

  // Shadow constants
  static final BoxShadow iconBoxShadow = BoxShadow(
    color: AppColors.neutralBlack.withValues(alpha: 0.1),
    offset: const Offset(0, 4),
    blurRadius: 10,
  );

  @override
  Widget build(BuildContext context) {
    final distanceInMeters =
        merchantAgency.distance ??
        merchantAgency.location.distanceTo(currentLocation).toDouble();
    final distanceText = distanceInMeters > meterPerKiloMeter
        ? '${(distanceInMeters / meterPerKiloMeter).toStringAsFixed(1)}km'
        : '${distanceInMeters.toStringAsFixed(0)}m';

    return SizedBox(
      height: cardHeight,
      child: Row(
        children: [
          buildLogoWithBadge(),
          UIGaps.w12,

          /// Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  merchantAgency.name,
                  style: AppTextStyles.bodyExtraSmall.copyWith(
                    color: AppColors.primaryForest,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: nameToDescriptionSpacing),
                Text(
                  merchantAgency.merchant.description,
                  style: AppTextStyles.bodyExtraSmall.copyWith(
                    color: AppColors.primaryForest.withValues(alpha: 0.5),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          UIGaps.w8,

          /// Distance + actions
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                spacing: UIGaps.size4,
                children: [
                  _buildDealRateIcontionIcon(merchantAgency.discount),
                  const Icon(
                    Icons.notifications_active_outlined,
                    size: actionIconSize,
                    color: AppColors.primaryForest,
                  ),
                  const Icon(
                    Icons.favorite_border_outlined,
                    size: actionIconSize,
                    color: AppColors.primaryForest,
                  ),
                ],
              ),
              UIGaps.h8,

              Text(
                distanceText,
                style: AppTextStyles.bodyExtraSmall.copyWith(
                  color: AppColors.primaryForest.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDealRateIcontionIcon(double dealRate) => SizedBox(
    width: iconSize,
    height: dealRateContainerHeight,
    child: Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/deal_border.svg',
          height: iconSize,
          width: iconSize,
        ),
        Text(
          '-$dealRate',
          style: const TextStyle(
            fontSize: dealRateFontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryCoral, // text color tuỳ chỉnh
          ),
        ),
      ],
    ),
  );

  Widget buildLogoWithBadge() => Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        width: MerchantDealCard.iconSize,
        padding: const EdgeInsets.all(logoPadding),
        height: MerchantDealCard.iconSize,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Rounded.xl,
          boxShadow: [MerchantDealCard.iconBoxShadow],
        ),
        child: ClipRRect(
          borderRadius: Rounded.md,
          child: Image.network(
            merchantAgency.merchant.logoUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                const Icon(Icons.store, size: errorIconSize),
          ),
        ),
      ),

      /// Discount badge
    ],
  );
}

class MerchantDealCardSkeleton extends StatelessWidget {
  const MerchantDealCardSkeleton({super.key});

  static const double cardHeight = 72;
  static const double iconSize = 40;
  static const double actionIconSize = 22;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: AppColors.neutralGrey,
    highlightColor: AppColors.neutralWhite,
    child: SizedBox(
      height: cardHeight,
      child: Row(
        children: [
          // Logo skeleton
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: AppColors.neutralWhite,
              borderRadius: Rounded.xl,
            ),
          ),
          UIGaps.w12,

          // Info section skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Merchant name skeleton
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: Rounded.xs,
                  ),
                ),
                UIGaps.h4,
                // Description skeleton
                Container(
                  height: 12,
                  width: 150,
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: Rounded.xs,
                  ),
                ),
              ],
            ),
          ),

          UIGaps.w8,

          // Action icons skeleton
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                spacing: UIGaps.size4,
                children: [
                  Container(
                    width: actionIconSize,
                    height: actionIconSize,
                    decoration: BoxDecoration(
                      color: AppColors.neutralWhite,
                      borderRadius: Rounded.xs,
                    ),
                  ),
                  Container(
                    width: actionIconSize,
                    height: actionIconSize,
                    decoration: BoxDecoration(
                      color: AppColors.neutralWhite,
                      borderRadius: Rounded.xs,
                    ),
                  ),
                  Container(
                    width: actionIconSize,
                    height: actionIconSize,
                    decoration: BoxDecoration(
                      color: AppColors.neutralWhite,
                      borderRadius: Rounded.xs,
                    ),
                  ),
                ],
              ),
              UIGaps.h8,
              // Distance skeleton
              Container(
                height: 12,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.neutralWhite,
                  borderRadius: Rounded.xs,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
