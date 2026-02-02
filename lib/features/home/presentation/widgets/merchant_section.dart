import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_bloc.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_event.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_state.dart';
import 'package:fpt_ojt/features/home/presentation/constants/text.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/mechant_deal_card.dart';
import 'package:fpt_ojt/features/location/blocs/location_bloc.dart';
import 'package:fpt_ojt/features/location/blocs/location_state.dart';

class MerchantSection extends StatelessWidget {
  const MerchantSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    spacing: UIGaps.size8,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_buildTitle(), _buildMerchantList()],
  );

  Widget _buildTitle() => Text(
    HomeText.merchantBestOfferTitle,
    style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
  );

  Widget _buildMerchantList() => BlocBuilder<HomeBloc, HomeState>(
    builder: (context, homeState) {
      if (homeState.agenciesStatus == HomeLoadStatus.failure) {
        return _buildErrorState(homeState.errorMessage);
      }

      return BlocConsumer<LocationBloc, LocationState>(
        listener: _handleLocationUpdate,
        builder: (context, locationState) =>
            _buildContent(homeState, locationState),
      );
    },
  );

  Widget _buildErrorState(String? errorMessage) =>
      Text(errorMessage ?? 'An error occurred');

  void _handleLocationUpdate(
    BuildContext context,
    LocationState locationState,
  ) {
    if (locationState.current != null) {
      context.read<HomeBloc>().add(
        HomeCoordinateUpdated(locationState.current!),
      );
    }
  }

  Widget _buildContent(HomeState homeState, LocationState locationState) {
    if (homeState.agenciesStatus == HomeLoadStatus.loading) {
      return _buildLoadingState();
    }

    if (_shouldShowEmptyState(homeState, locationState)) {
      return _buildEmptyState();
    }

    return _buildMerchantCards(homeState, locationState);
  }

  Widget _buildLoadingState() => const SizedBox(
    height: 80,
    child: Center(child: CircularProgressIndicator()),
  );

  bool _shouldShowEmptyState(
    HomeState homeState,
    LocationState locationState,
  ) =>
      homeState.nearestMerchantAgencies.isEmpty ||
      locationState.current == null;

  Widget _buildEmptyState() => const SizedBox(height: 80);

  Widget _buildMerchantCards(
    HomeState homeState,
    LocationState locationState,
  ) => Column(
    spacing: UIGaps.size8,
    children: homeState.nearestMerchantAgencies
        .map(
          (agency) => MerchantDealCard(
            merchantAgency: agency,
            currentLocation: locationState.current!,
          ),
        )
        .toList(),
  );
}
