import 'package:fpt_ojt/features/merchants/data/models/merchant_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_agency_model.freezed.dart';
part 'merchant_agency_model.g.dart';

@freezed
abstract class MerchantAgencyModel with _$MerchantAgencyModel {
  const factory MerchantAgencyModel({
    required String id,
    required String name,
    required MerchantModel merchant,
    double? longitude,
    double? latitude,
    String? imageUrl,
  }) = _MerchantAgencyModel;

  factory MerchantAgencyModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantAgencyModelFromJson(json);
}
