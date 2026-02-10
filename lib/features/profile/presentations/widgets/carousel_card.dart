import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/profile/presentations/models/carousel_item.dart';

class CarouselCard extends StatelessWidget {
  const CarouselCard({required this.item, super.key});
  final CarouselItem item;
  static const int bgOpacity = 25;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: Rounded.sm,

    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(item.image, fit: BoxFit.cover),
        Container(color: Colors.black.withAlpha(bgOpacity)),
        Padding(
          padding: const EdgeInsets.all(UIGaps.size16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                item.title,
                style: AppTextStyles.title.copyWith(
                  color: AppColors.neutralWhite,
                ),
              ),
              UIGaps.h8,
              Text(
                item.description,
                style: AppTextStyles.bodyExtraSmall.copyWith(
                  color: AppColors.neutralWhite,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
