import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';

class SearchInputTextField extends StatelessWidget {
  const SearchInputTextField({super.key, this.onSubmitted, this.controller});
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  static const String hintText = "I'm looking for...";
  static const double iconSize = 24;
  static const double inputHeight = 48;
  static const double inputWidth = 274;
  static const double inputHorizontalPadding = 16;
  static const double inputVerticalPadding = 13;
  @override
  Widget build(BuildContext context) => Container(
    width: inputWidth,
    height: inputHeight,
    alignment: Alignment.center,
    child: TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      style: AppTextStyles.bodyExtraSmall.copyWith(
        color: AppColors.primaryForest,
      ),
      cursorColor: AppColors.primaryForest,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyExtraSmall.copyWith(
          color: AppColors.primaryForest,
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: inputHorizontalPadding,
          vertical: inputVerticalPadding,
        ),
        suffixIcon: const Padding(
          padding: EdgeInsets.only(right: UIGaps.size16),
          child: Icon(
            Icons.search,
            color: AppColors.primaryForest,
            size: iconSize,
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
          maxHeight: iconSize,
          maxWidth: iconSize + UIGaps.size16,
        ),
      ),
    ),
  );
}
