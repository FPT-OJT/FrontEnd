import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:shimmer/shimmer.dart';

class CardOptionSkeleton extends StatelessWidget {
  const CardOptionSkeleton({super.key});

  // UI Constants
  static const double shimmerBaseAlpha = 0.1;
  static const double shimmerHighlightAlpha = 0.05;
  static const double iconPlaceholderSize = 20;
  static const double textHeightLarge = 14;
  static const double textHeightSmall = 12;
  static const double textWidthSmall = 100;
  static const double textWidthMedium = 120;
  static const double textWidthLarge = 150;
  static const double textWidth80 = 80;
  static const double textWidth90 = 90;
  static const double cardImageWidth = 120;
  static const double cardImageHeight = 80;
  static const double borderRadius4 = 4;
  static const double borderRadius8 = 8;
  static const double dotMarginHorizontal = 4;
  static const double dotSize = 8;
  static const int dotCount = 3;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: UIGaps.size8),
    child: Shimmer.fromColors(
      baseColor: AppColors.primaryForest.withValues(
        alpha: CardOptionSkeleton.shimmerBaseAlpha,
      ),
      highlightColor: AppColors.primaryForest.withValues(
        alpha: CardOptionSkeleton.shimmerHighlightAlpha,
      ),
      child: Column(
        spacing: UIGaps.size20,
        children: [
          // Header row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: UIGaps.size8,
            children: [
              // Icon placeholder
              Container(
                width: CardOptionSkeleton.iconPlaceholderSize,
                height: CardOptionSkeleton.iconPlaceholderSize,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),

              // Text placeholders
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: UIGaps.size4,
                  children: [
                    Container(
                      height: CardOptionSkeleton.textHeightLarge,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          CardOptionSkeleton.borderRadius4,
                        ),
                      ),
                    ),
                    Container(
                      height: CardOptionSkeleton.textHeightSmall,
                      width: CardOptionSkeleton.textWidthSmall,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          CardOptionSkeleton.borderRadius4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Right section placeholder
              Container(
                height: CardOptionSkeleton.textHeightLarge,
                width: CardOptionSkeleton.textWidth80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    CardOptionSkeleton.borderRadius4,
                  ),
                ),
              ),
            ],
          ),

          // Card image and details section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Card image placeholder
              Container(
                width: CardOptionSkeleton.cardImageWidth,
                height: CardOptionSkeleton.cardImageHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    CardOptionSkeleton.borderRadius8,
                  ),
                ),
              ),

              // Card details placeholder
              Column(
                spacing: UIGaps.size4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: CardOptionSkeleton.textHeightLarge,
                    width: CardOptionSkeleton.textWidthMedium,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        CardOptionSkeleton.borderRadius4,
                      ),
                    ),
                  ),
                  Container(
                    height: CardOptionSkeleton.textHeightSmall,
                    width: CardOptionSkeleton.textWidthSmall,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        CardOptionSkeleton.borderRadius4,
                      ),
                    ),
                  ),
                  Container(
                    height: CardOptionSkeleton.textHeightSmall,
                    width: CardOptionSkeleton.textWidth90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        CardOptionSkeleton.borderRadius4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Detailed conditions placeholder
          Center(
            child: Container(
              height: CardOptionSkeleton.textHeightLarge,
              width: CardOptionSkeleton.textWidthLarge,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  CardOptionSkeleton.borderRadius4,
                ),
              ),
            ),
          ),

          // Page indicator dots placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              CardOptionSkeleton.dotCount,
              (index) => Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: CardOptionSkeleton.dotMarginHorizontal,
                ),
                width: CardOptionSkeleton.dotSize,
                height: CardOptionSkeleton.dotSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
