import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_bloc.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_state.dart';
import 'package:fpt_ojt/features/home/presentation/constants/text.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/mechant_deal_card.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/location.dart';

const currentLocaltion = Location(longitude: 106.699419, latitude: 10.771918);

class MerchantSection extends StatelessWidget {
  const MerchantSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    spacing: UIGaps.size8,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        HomeText.merchantBestOfferTitle,
        style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
      ),
      BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.agenciesStatus == LoadStatus.loading) {
            return const SizedBox(height: 80);
          }
          if (state.agenciesStatus == LoadStatus.failure) {
            return Text(state.errorMessage ?? 'An error occurred');
          }

          return Column(
            children: state.nearestMerchantAgencies
                .map(
                  (agency) => MerchantDealCard(
                    merchantAgency: agency,
                    currentLocation: currentLocaltion,
                  ),
                )
                .toList(),
          );
        },
      ),
    ],
  );
}
