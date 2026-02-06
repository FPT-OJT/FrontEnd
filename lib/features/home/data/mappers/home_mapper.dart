import 'package:fpt_ojt/features/home/data/models/home_data.dart';
import 'package:fpt_ojt/features/home/data/models/merchant_category.dart'
    as model;
import 'package:fpt_ojt/features/home/data/models/merchant_offer.dart' as model;
import 'package:fpt_ojt/features/home/data/models/product_deal.dart' as model;
import 'package:fpt_ojt/features/home/domain/entities/merchant_category.dart'
    as entity;
import 'package:fpt_ojt/features/home/domain/entities/merchant_offer.dart'
    as entity;
import 'package:fpt_ojt/features/home/domain/entities/product_deal.dart'
    as entity;
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';

extension MerchantCategoryMapper on model.MerchantCategory {
  entity.MerchantCategory toEntity() =>
      entity.MerchantCategory(id: id, name: name, imageUrl: imageUrl);
}

extension MerchantOfferMapper on model.MerchantOffer {
  entity.MerchantOffer toEntity() => entity.MerchantOffer(
    merchantAgencyId: merchantAgencyId,
    merchantAgencyName: merchantAgencyName,
    merchantDealName: merchantDealName,
    imageUrl: imageUrl,
    totalDiscount: totalDiscount,
    favorite: favorite,
    location: lat != null && lng != null
        ? Coordinate(latitude: lat!, longitude: lng!)
        : null,
    subscribed: subscribed,
    distance: distance,
  );
}

extension ProductDealMapper on model.ProductDeal {
  entity.ProductDeal toEntity() => entity.ProductDeal(
    name: name,
    imageUrl: imageUrl,
    originalPrice: originalPrice,
    discountedPrice: discountedPrice,
    discountPercentage: discountPercentage,
  );
}

extension HomeDataMapper on HomeData {
  ({
    List<entity.MerchantCategory> categories,
    List<entity.MerchantOffer> offers,
    List<entity.ProductDeal> productDeals,
  })
  toEntities() => (
    categories: merchantCategories.map((e) => e.toEntity()).toList(),
    offers: merchantOffers.map((e) => e.toEntity()).toList(),
    productDeals: productDeals.map((e) => e.toEntity()).toList(),
  );
}
