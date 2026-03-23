import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_deal.freezed.dart';
part 'product_deal.g.dart';

@Freezed()
abstract class ProductDeal with _$ProductDeal {
  const factory ProductDeal({
    String? name,
    String? imageUrl,
    double? originalPrice,
    double? discountedPrice,
    double? discountPercentage,
  }) = _ProductDeal;

  factory ProductDeal.fromJson(Map<String, dynamic> json) =>
      _$ProductDealFromJson(json);
}
