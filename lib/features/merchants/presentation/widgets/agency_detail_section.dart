import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_bloc.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_event.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_state.dart';
import 'package:fpt_ojt/features/merchants/presentation/constants/merchant_detail.dart';
import 'package:fpt_ojt/features/shared/widgets/icon_button.dart';
import 'package:go_router/go_router.dart';

class AgencyDetailSection extends StatelessWidget {
  const AgencyDetailSection({this.name, super.key});
  final String? name;

  static const double containerHeight = 120;
  static const int nameMaxLines = 2;

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<MerchantDetailBloc, MerchantDetailState>(
    buildWhen: (prev, curr) =>
        curr is MerchantDetailLoaded &&
        (prev is! MerchantDetailLoaded ||
            prev.isFavorite != curr.isFavorite ||
            prev.isSubscribed != curr.isSubscribed),
    builder: (context, state) {
      final isFavorite = state is MerchantDetailLoaded && state.isFavorite;
      final isSubscribed = state is MerchantDetailLoaded && state.isSubscribed;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: UIGaps.size12),
        height: containerHeight,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppIconButton(
                  icon: Icons.arrow_back_ios_new,
                  onPressed: () => context.pop(),
                ),
                Row(
                  spacing: UIGaps.size4,
                  children: [
                    AppIconButton(
                      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? AppColors.secondaryPink : null,
                      onPressed: () => context.read<MerchantDetailBloc>().add(
                        const MerchantDetailFavoriteToggled(),
                      ),
                    ),
                    AppIconButton(
                      icon: isSubscribed
                          ? Icons.notifications_active
                          : Icons.notification_add_outlined,
                      color: isSubscribed ? AppColors.primaryCoin : null,
                      onPressed: () => context.read<MerchantDetailBloc>().add(
                        const MerchantDetailSubscribeToggled(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              name ?? MerchantDetailText.emptyString,
              style: AppTextStyles.h2.copyWith(color: AppColors.neutralWhite),
              maxLines: nameMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    },
  );
}
