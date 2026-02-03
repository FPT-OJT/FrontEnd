import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_bloc.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_state.dart';
import 'package:fpt_ojt/features/home/presentation/constants/text.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/category_card.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/category_card_skeleton.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/search_input.dart';
import 'package:go_router/go_router.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  static const int maxSkeletonToShow = 9;
  static const double skeletonWidth = 90;

  @override
  Widget build(BuildContext context) => Column(
    spacing: UIGaps.size20,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        HomeText.searchTitle,
        style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
      ),
      SearchInput(
        onTap: () {
          context.push(RouteNames.search);
        },
      ),
      BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.categoriesStatus == HomeLoadStatus.loading &&
              state.categories.isEmpty) {
            return Wrap(
              spacing: UIGaps.size8,
              runSpacing: UIGaps.size16,
              children: List.generate(
                maxSkeletonToShow,
                (index) => const CategoryCardSkeleton(),
              ),
            );
          }
          if (state.categoriesStatus == HomeLoadStatus.failure &&
              state.categories.isEmpty) {
            return Center(
              child: Text(state.errorMessage ?? 'An error occurred'),
            );
          }
          return Wrap(
            spacing: UIGaps.size8,
            runSpacing: UIGaps.size16,
            children: state.categories
                .map(
                  (c) => CategoryCard(
                    label: c.name ?? '',
                    imageUrl: c.imageUrl ?? '',
                    onTap: () {
                      context.push(RouteNames.search);
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
    ],
  );
}
