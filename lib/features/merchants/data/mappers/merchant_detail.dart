import 'package:fpt_ojt/features/merchants/data/models/merchant_agency_cards_deals_response.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/card.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_deal_detail.dart';

extension CartDealMapper on DealItem {
  CardDeal toEntity() => CardDeal(
    cashbackRate: cashbackRate,
    dealId: dealId,
    dealName: dealName,
    description: description,
    discountRate: discountRate,
    pointsMultiplier: pointsMultiplier,
    type: type == DealType.merchantDeal ? CardDealType.merchantDeal : CardDealType.cardDeal,
    validFrom: validFrom,
    validTo: validTo,
  );
}

extension CardDealMapper on CardWithDeals {
  Card toEntity() => Card(
    imageUrl: cardImageUrl??'',
    name: cardName,
    productId: cardProductId,
    type: cardType,
    deals: deals.map((e) => e.toEntity()).toList(),
  );
}

extension MerchantAgencyCardsDealsResponseMapper on MerchantAgencyCardsDealsResponse {
  MerchantDetailWithCardDeals toEntity() => MerchantDetailWithCardDeals(
    cards: cards.map((e) => e.toEntity()).toList(),
    agencyId: merchantAgencyId,
    agencyName: merchantAgencyName,
    imageUrl: imageUrl??'',
  );
}