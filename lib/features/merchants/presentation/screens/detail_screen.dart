import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_bloc.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_event.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_state.dart';
import 'package:fpt_ojt/features/merchants/presentation/widgets/agency_detail_section.dart';
import 'package:fpt_ojt/features/merchants/presentation/widgets/bottom_selected_card_section.dart';
import 'package:fpt_ojt/features/merchants/presentation/widgets/card_options_section.dart';
import 'package:shimmer/shimmer.dart';

class MerchantDetailScreen extends StatefulWidget {
  const MerchantDetailScreen({required this.merchantId, super.key});
  final String merchantId;

  @override
  State<MerchantDetailScreen> createState() => _MerchantDetailScreenState();
}

class _MerchantDetailScreenState extends State<MerchantDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MerchantDetailBloc>().add(
      MerchantDetailStarted(merchantId: widget.merchantId),
    );
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.primaryForest,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    child: Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.primaryForest,
            child: Column(
              children: [
                BlocBuilder<MerchantDetailBloc, MerchantDetailState>(
                  builder: (context, state) => Container(
                    decoration:
                        (state is MerchantDetailLoaded &&
                            state.merchantDetail.imageUrl.isNotEmpty)
                        ? BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                state.merchantDetail.imageUrl,
                              ),
                              fit: BoxFit.fitWidth,
                              colorFilter: ColorFilter.mode(
                                AppColors.primaryForest.withValues(alpha: 0.6),
                                BlendMode.darken,
                              ),
                            ),
                          )
                        : null,
                    height: 180,
                    padding: const EdgeInsets.only(
                      left: UIGaps.size20,
                      right: UIGaps.size20,
                      top: UIGaps.size48,
                      bottom: UIGaps.size20,
                    ),
                    child: (state is MerchantDetailLoaded)
                        ? const AgencyDetailSection(name: 'Starbucks New World')
                        : Shimmer.fromColors(
                            baseColor: AppColors.primaryForest.withValues(
                              alpha: 0.1,
                            ),
                            highlightColor: AppColors.primaryForest.withValues(
                              alpha: 0.05,
                            ),
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              color: AppColors.primaryForest.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                  ),
                ),
                const Expanded(child: _ContentSection()),
              ],
            ),
          ),

          // Bottom Selected Card Section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomSelectedCardSection(
              onContinue: () {
                // TODO: Handle continue action
                debugPrint('Continue pressed');
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class _ContentSection extends StatelessWidget {
  const _ContentSection();

  // UI Constants
  static const double borderRadius = 16;
  static const double minHeight = 700;
  static const double bottomPadding = 140; // Add padding for bottom section

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.only(
      left: UIGaps.size20,
      right: UIGaps.size20,
      bottom: _ContentSection.bottomPadding,
    ),
    decoration: const BoxDecoration(
      color: AppColors.neutralEggShell20,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(_ContentSection.borderRadius),
        topRight: Radius.circular(_ContentSection.borderRadius),
      ),
    ),
    width: double.infinity,
    constraints: const BoxConstraints(minHeight: _ContentSection.minHeight),
    child: const SingleChildScrollView(
      child: Column(
        spacing: UIGaps.size20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [CardOptionsSection()],
      ),
    ),
  );
}
