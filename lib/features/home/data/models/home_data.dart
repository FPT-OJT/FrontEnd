import 'package:fpt_ojt/features/home/data/models/merchant_category.dart';
import 'package:fpt_ojt/features/home/data/models/merchant_offer.dart';
import 'package:fpt_ojt/features/home/data/models/product_deal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_data.freezed.dart';

@Freezed()
abstract class HomeData with _$HomeData {
  const factory HomeData({
    required List<MerchantCategory> merchantCategories,
    required List<MerchantOffer> merchantOffers,
    required List<ProductDeal> productDeals,
    required bool hasCard,
  }) = _HomeData;

  factory HomeData.fromJson(Map<String, dynamic> json) {
    // Mock data cho productDeals nếu backend chưa có
    final mockProductDeals = List.generate(
      3,
      (index) => const ProductDeal(
        imageUrl:
            'https://res.cloudinary.com/dzpv3mfjt/image/upload/v1770090200/food_deal_scfi3l.png',
        name: 'Seasoned coconut chicken bowl',
        originalPrice: 40,
        discountedPrice: 32,
        discountPercentage: 20,
      ),
    );

    return HomeData(
      merchantCategories:
          (json['merchantCategories'] as List<dynamic>?)
              ?.map((e) => MerchantCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      merchantOffers:
          (json['merchantOffers'] as List<dynamic>?)
              ?.map((e) => MerchantOffer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      productDeals:
          (json['productDeals'] as List<dynamic>?)
              ?.map((e) => ProductDeal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          mockProductDeals,
      hasCard: json['hasCard'] as bool? ?? false,
    );
  }
}
