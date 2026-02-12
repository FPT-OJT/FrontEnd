import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_agency_cards_deals_response.freezed.dart';
part 'merchant_agency_cards_deals_response.g.dart';

@freezed
abstract class MerchantAgencyCardsDealsResponse
    with _$MerchantAgencyCardsDealsResponse {
  const factory MerchantAgencyCardsDealsResponse({
    required String merchantAgencyId,
    required String merchantAgencyName,
    required List<CardWithDeals> cards, String? imageUrl,
  }) = _MerchantAgencyCardsDealsResponse;

  factory MerchantAgencyCardsDealsResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$MerchantAgencyCardsDealsResponseFromJson(json);
}

@freezed
abstract class CardWithDeals with _$CardWithDeals {
  const factory CardWithDeals({
    required String userCardId,
    required String cardProductId,
    required String cardName,
    required String cardType, required List<DealItem> deals, String? cardImageUrl,
  }) = _CardWithDeals;

  factory CardWithDeals.fromJson(Map<String, dynamic> json) =>
      _$CardWithDealsFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum DealType { merchantDeal, cardDeal }

@freezed
abstract class DealItem with _$DealItem {
  const factory DealItem({
    required DealType type,
    String? dealId,
    String? dealName,
    double? discountRate,
    double? cashbackRate,
    double? pointsMultiplier,
    String? description,
    DateTime? validFrom,
    DateTime? validTo,
  }) = _DealItem;

  factory DealItem.fromJson(Map<String, dynamic> json) =>
      _$DealItemFromJson(json);
}
