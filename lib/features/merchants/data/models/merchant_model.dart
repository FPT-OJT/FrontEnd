import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_model.freezed.dart';
part 'merchant_model.g.dart';

@freezed
abstract class MerchantModel with _$MerchantModel {
  const factory MerchantModel({
    required String id,
    required String name,
    required String mcc,
    String? description,
    String? logoUrl,
  }) = _MerchantModel;

  factory MerchantModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantModelFromJson(json);
}
