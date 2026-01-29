import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/features/home/presentation/constants/text.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key, this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 335,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            HomeText.searchPlaceholder,
            style: TextStyle(
              color: AppColors.primaryForest,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          Icon(Icons.search_outlined, size: 24, color: Colors.black54),
        ],
      ),
    ),
  );
}
