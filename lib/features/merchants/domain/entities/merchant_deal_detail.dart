import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/card.dart';

class MerchantDetailWithCardDeals extends Equatable {
  const MerchantDetailWithCardDeals({
    required this.cards,
    required this.agencyId,
    required this.agencyName,
    required this.imageUrl,
  });
  final List<Card> cards;
  final String agencyId;
  final String agencyName;
  final String imageUrl;

  double get bestReduceRate {
    final maxReduceRate = cards
        .expand((card) => card.deals)
        .map((deal) => deal.maxReduceRate)
        .fold<num>(0, (max, value) => value > max ? value : max);

    return maxReduceRate.toDouble();
  }

  @override
  List<Object?> get props => [cards, agencyId, agencyName, imageUrl];
}
