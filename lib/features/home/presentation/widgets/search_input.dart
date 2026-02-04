import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
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
    child: Hero(
      tag: 'search_box',
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: inputWidth,
          height: inputHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.neutralWhite,
            borderRadius: Rounded.xs,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                offset: shadowOffset,
                blurRadius: shadowBlurRadius,
              ),
            ],
          ),
          child: IgnorePointer(
            child: TextField(
              enabled: false,
              style: AppTextStyles.bodyExtraSmall.copyWith(
                color: AppColors.primaryForest,
              ),
              decoration: InputDecoration(
                hintText: HomeText.searchPlaceholder,
                hintStyle: AppTextStyles.bodyExtraSmall.copyWith(
                  color: AppColors.primaryForest,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.search,
                    color: AppColors.primaryForest,
                    size: 24,
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(
                  maxHeight: 24,
                  maxWidth: 40,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
