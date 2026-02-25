import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_agency_search_result_model.freezed.dart';
part 'merchant_agency_search_result_model.g.dart';

@freezed
abstract class MerchantAgencySearchResultModel
    with _$MerchantAgencySearchResultModel {
  const factory MerchantAgencySearchResultModel({
    required String agencyId,
    required String agencyName,
    required String merchantName,
    double? latitude,
    double? longitude,
    String? logoUrl,
    String? description,
    double? distanceMeters,
  }) = _MerchantAgencySearchResultModel;

  factory MerchantAgencySearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantAgencySearchResultModelFromJson(json);
}
