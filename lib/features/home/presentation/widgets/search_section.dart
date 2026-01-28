import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/search_input.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    spacing: UIGaps.size20,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Search for merchants',
        style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
      ),
      const SearchInput(),
    ],
  );
}
