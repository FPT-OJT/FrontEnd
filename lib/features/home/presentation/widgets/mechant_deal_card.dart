import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';

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
    final distance =
        merchantAgency.distance ??
        merchantAgency.location.distanceTo(currentLocation);
    final distanceText = distance > meterPerKiloMeter
        ? '${(distance / meterPerKiloMeter).toStringAsFixed(1)}km'
        : '${distance}m';

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
