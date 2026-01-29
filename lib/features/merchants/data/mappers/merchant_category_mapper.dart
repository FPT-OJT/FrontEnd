import 'package:fpt_ojt/features/merchants/data/models/merchant_category.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_category.dart';

extension MerchantCategoryModelMapper on CategoryModel {
  MerchantCategory toEntity() => MerchantCategory(
    categoryName: categoryName,
    imageUrl: imageUrl,
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension MerchantCategoryListModelMapper on List<CategoryModel> {
  List<MerchantCategory> toEntity() => map((e) => e.toEntity()).toList();
}
