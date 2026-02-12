import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fpt_ojt/features/merchants/presentations/blocs/merchant_detail/merchant_detail_bloc.dart';
import 'package:fpt_ojt/features/merchants/presentations/blocs/merchant_detail/merchant_detail_event.dart';
import 'package:fpt_ojt/features/merchants/presentations/blocs/merchant_detail/merchant_detail_state.dart';
import 'package:fpt_ojt/features/merchants/presentations/widgets/card_option.dart';
import 'package:fpt_ojt/features/merchants/presentations/widgets/card_option_skeleton.dart';

class CardOptionsSection extends StatelessWidget {
  const CardOptionsSection({super.key});

  // UI Constants
  static const int skeletonLoadingCount = 3;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<MerchantDetailBloc, MerchantDetailState>(
        builder: (context, state) {
          if (state is MerchantDetailLoading) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: CardOptionsSection.skeletonLoadingCount,
              itemBuilder: (context, index) => const CardOptionSkeleton(),
            );
          }
          if (state is! MerchantDetailLoaded) {
            return const SizedBox.shrink();
          }

          final listCards = state.merchantDetail.cards
              .where((card) => card.deals.isNotEmpty)
              .toList();

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listCards.length,
            itemBuilder: (context, index) {
              final card = listCards[index];
              return CardOption(
                card: card,
                selectOptionTap: () {
                  context.read<MerchantDetailBloc>().add(
                    MerchantDetailCardSelected(card: card),
                  );
                },
                isSelected: state.selectedCard?.productId == card.productId,
              );
            },
          );
        },
      );
}
