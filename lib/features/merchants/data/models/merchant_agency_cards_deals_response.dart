import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_agency_cards_deals_response.freezed.dart';
part 'merchant_agency_cards_deals_response.g.dart';

@freezed
abstract class MerchantAgencyCardsDealsResponse
    with _$MerchantAgencyCardsDealsResponse {
  const factory MerchantAgencyCardsDealsResponse({
    required String merchantAgencyId,
    required String merchantAgencyName,
    String? imageUrl,
    required List<CardWithDeals> cards,
  }) = _MerchantAgencyCardsDealsResponse;

  factory MerchantAgencyCardsDealsResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$MerchantAgencyCardsDealsResponseFromJson(json);
}

@freezed
abstract class CardWithDeals with _$CardWithDeals {
  const factory CardWithDeals({
    required String userCardId,
    required String cardProductId,
    required String cardName,
    String? cardImageUrl,
    required String cardType,
    required List<DealItem> deals,
  }) = _CardWithDeals;

  factory CardWithDeals.fromJson(Map<String, dynamic> json) =>
      _$CardWithDealsFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum DealType {
  MERCHANT_DEAL,
  CARD_DEAL,
}

@freezed
abstract class DealItem with _$DealItem {
  const factory DealItem({
    required DealType type,
    required String dealId,
    required String dealName,
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
