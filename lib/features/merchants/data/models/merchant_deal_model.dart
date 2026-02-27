import 'package:freezed_annotation/freezed_annotation.dart';
part 'merchant_deal_model.freezed.dart';
part 'merchant_deal_model.g.dart';

@freezed
abstract class MerchantDealModel with _$MerchantDealModel {
  const factory MerchantDealModel({
    required String id,
    required String merchantName,
    required String logoUrl,
    required String merchantDescription,
    required String agencyId,
    required String agencyName,
    required String dealName,
    @Default(0) double discountRate,
    @Default(0) double cashbackRate,
    @Default(0) double pointsMultiplier,
    required String description,
  }) = _MerchantDealModel;

  factory MerchantDealModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantDealModelFromJson(json);
}
