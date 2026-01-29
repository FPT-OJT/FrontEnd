import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_bloc.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_state.dart';
import 'package:fpt_ojt/features/home/presentation/constants/text.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/category_card.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/search_input.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    spacing: UIGaps.size20,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        HomeText.searchTitle,
        style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
      ),
      const SearchInput(),
      BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          debugPrint('state: ${state.status}');
          debugPrint('state categories length: ${state.categories.length}');
          if (state.status == HomeStatus.loading && state.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == HomeStatus.failure && state.categories.isEmpty) {
            return Center(
              child: Text(state.errorMessage ?? 'An error occurred'),
            );
          }
          return Wrap(
            spacing: UIGaps.size8,
            runSpacing: UIGaps.size16,
            children: state.categories
                .map(
                  (c) =>
                      CategoryCard(label: c.categoryName, imageUrl: c.imageUrl),
                )
                .toList(),
          );
        },
      ),
    ],
  );
}
