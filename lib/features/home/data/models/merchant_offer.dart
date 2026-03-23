import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_offer.freezed.dart';
part 'merchant_offer.g.dart';

@Freezed()
abstract class MerchantOffer with _$MerchantOffer {
  const factory MerchantOffer({
    String? merchantAgencyId,
    String? merchantAgencyName,
    String? merchantDealName,
    String? imageUrl,
    double? totalDiscount,
    bool? favorite,
    bool? subscribed,
    double? distance,
    double? lat,
    double? lng,
  }) = _MerchantOffer;

  factory MerchantOffer.fromJson(Map<String, dynamic> json) =>
      _$MerchantOfferFromJson(json);
}
