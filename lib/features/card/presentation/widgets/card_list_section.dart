import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/card/domain/entities/card_entity.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/search/search_card_bloc.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/search/search_card_state.dart';
import 'package:fpt_ojt/features/card/presentation/constants/card_text.dart';
import 'package:fpt_ojt/features/card/presentation/widgets/card_detail_bottom_sheet.dart';
import 'package:fpt_ojt/features/card/presentation/widgets/card_item.dart';
import 'package:fpt_ojt/features/card/presentation/widgets/card_item_skeleton.dart';

class CardListSection extends StatelessWidget {
  const CardListSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    spacing: UIGaps.size20,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        CardText.cardListTitle,
        style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
      ),
      BlocBuilder<SearchCardBloc, SearchCardState>(
        builder: (context, state) {
          if (state.searchStatus == SearchCardLoadStatus.loading) {
            return _buildLoadingState();
          }

          if (state.searchStatus == SearchCardLoadStatus.failure) {
            return _buildErrorState(state.errorMessage);
          }

          if (state.searchStatus == SearchCardLoadStatus.success &&
              state.cards.isEmpty) {
            return _buildEmptyState();
          }

          return _buildCardsList(context, state);
        },
      ),
    ],
  );

  Widget _buildLoadingState() => Column(
    spacing: UIGaps.size12,
    children: List.generate(5, (_) => const CardItemSkeleton()),
  );

  Widget _buildErrorState(String? errorMessage) => Text(
    errorMessage ?? 'An error occurred',
    style: AppTextStyles.bodySmall.copyWith(color: AppColors.notifyError),
  );

  Widget _buildEmptyState() => Text(
    'No cards found',
    style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralGrey),
  );

  Widget _buildCardsList(BuildContext context, SearchCardState state) => Column(
    spacing: UIGaps.size12,
    children: state.cards
        .map(
          (card) => CardItem(
            id: card.id,
            cardName: card.name,
            imageUrl: card.imageUrl,
            onTap: () => _showCardDetailBottomSheet(context, card),
          ),
        )
        .toList(),
  );

  void _showCardDetailBottomSheet(BuildContext context, CardEntity card) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CardDetailBottomSheet(
        cardId: card.id,
        cardName: card.name,
        imageUrl: card.imageUrl,
      ),
    );
  }
}
