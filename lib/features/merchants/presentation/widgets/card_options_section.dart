import 'package:flutter/material.dart';
import 'package:fpt_ojt/features/merchants/presentations/widgets/card_option.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/card.dart'
    as card_entity;

class CardOptionsSection extends StatelessWidget {
  const CardOptionsSection({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    children: [
      CardOption(
        card: card_entity.Card(
          imageUrl: 'https://via.placeholder.com/150',
          name: 'Card 1',
          productId: '1',
          type: 'card',
          deals: [card_entity.CardDeal(discountRate: 10, cashbackRate: 10)],
        ),
      ),
    ],
  );
}
