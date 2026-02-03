import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_category.freezed.dart';
part 'merchant_category.g.dart';

@Freezed()
abstract class MerchantCategory with _$MerchantCategory {
  const factory MerchantCategory({String? id, String? name, String? imageUrl}) =
      _MerchantCategory;

  factory MerchantCategory.fromJson(Map<String, dynamic> json) =>
      _$MerchantCategoryFromJson(json);
}
