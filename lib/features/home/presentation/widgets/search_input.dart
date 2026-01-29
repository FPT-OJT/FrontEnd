import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/home/presentation/constants/text.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key, this.onTap});
  final void Function()? onTap;

  static const double inputWidth = 335;
  static const double inputHeight = 48;
  static Color shadowColor = Colors.black26;
  static const double shadowBlurRadius = 4;
  static Offset shadowOffset = const Offset(0, 2);
  static const double searchIconSize = 24;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: inputWidth,
      height: inputHeight,
      padding: const EdgeInsets.symmetric(horizontal: UIGaps.size16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Rounded.xs,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: shadowOffset,
            blurRadius: shadowBlurRadius,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            HomeText.searchPlaceholder,
            style: AppTextStyles.bodyExtraSmall.copyWith(
              color: AppColors.primaryForest,
            ),
          ),
          const Icon(
            Icons.search_outlined,
            size: searchIconSize,
            color: AppColors.primaryForest,
          ),
        ],
      ),
    ),
  );
}
