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


class MerchantDealDetail extends Equatable {
  const MerchantDealDetail({
    required this.id,
    required this.merchantName,
    required this.agencyId,
    required this.logoUrl,
    required this.merchantDescription,
    required this.agencyName,
    required this.dealName,
    required this.discountRate,
    required this.cashbackRate,
    required this.pointsMultiplier,
    required this.description,
  });
  final String id;
  final String merchantName;
  final String agencyId;
  final String logoUrl;
  final String merchantDescription;
  final String agencyName;
  final String dealName;
  final double discountRate;
  final double cashbackRate;
  final double pointsMultiplier;
  final String description;
  @override
  List<Object?> get props => [id, merchantName, logoUrl, merchantDescription, agencyName, dealName, discountRate, cashbackRate, pointsMultiplier, description];
}