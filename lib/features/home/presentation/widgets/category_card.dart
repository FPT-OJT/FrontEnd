import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';

class CategoryCard extends StatelessWidget {

  const CategoryCard({
    required this.label,
    required this.imageUrl,
    super.key,
    this.onTap,
  });
  final String label;
  final String imageUrl;
  final VoidCallback? onTap;
  static const double categoryCardHeight = 36;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min, 
      children: [
        Container(
          height: categoryCardHeight,
          padding: const EdgeInsets.symmetric(horizontal: UIGaps.size16,vertical: UIGaps.size10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: Rounded.xs,
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withAlpha(77),
                BlendMode.darken,
              ),
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.textLink.copyWith(color: AppColors.neutralWhite),
          ),
        ),
      ],
    ),
  );
}
