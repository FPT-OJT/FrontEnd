import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_bloc.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_state.dart';
import 'package:fpt_ojt/features/home/presentation/constants/text.dart';

class FoodDealSection extends StatelessWidget {
  const FoodDealSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    spacing: UIGaps.size8,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_buildTitle(), _buildFoodList()],
  );

  Widget _buildTitle() => Text(
    HomeText.foodDealsTitle,
    style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
  );

  Widget _buildFoodList() => BlocBuilder<HomeBloc, HomeState>(
    builder: (context, state) {
      if (state.agenciesStatus == HomeLoadStatus.failure) {
        return _buildErrorState(state.errorMessage);
      }
      return _buildContent(state);
    },
  );

  Widget _buildErrorState(String? errorMessage) =>
      Text(errorMessage ?? 'An error occurred');

  Widget _buildContent(HomeState state) {
    if (state.agenciesStatus == HomeLoadStatus.loading) {
      return _buildLoadingState();
    }

    if (state.productDeals.isEmpty) {
      return _buildEmptyState();
    }

    return _buildFoodCards(state);
  }

  Widget _buildLoadingState() => const SizedBox(height: 100);

  Widget _buildEmptyState() => const SizedBox(height: 80);

  Widget _buildFoodCards(HomeState state) => SizedBox(
    height: 200,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: state.productDeals.length,
      separatorBuilder: (_, _) => UIGaps.w12,
      itemBuilder: (context, index) => Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.neutralWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                state.productDeals[index].imageUrl ?? '',
                height: 100,
                width: 160,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(height: 100, color: AppColors.neutralGrey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.productDeals[index].name ?? '',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  UIGaps.h4,
                  Row(
                    children: [
                      Text(
                        '\$${state.productDeals[index].discountedPrice?.toStringAsFixed(2)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.secondaryCoral,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      UIGaps.w4,
                      Text(
                        '\$${state.productDeals[index].originalPrice?.toStringAsFixed(2)}',
                        style: AppTextStyles.bodyExtraSmall.copyWith(
                          color: AppColors.neutralGrey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
