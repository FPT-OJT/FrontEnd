import 'package:freezed_annotation/freezed_annotation.dart';
part 'merchant_category.freezed.dart';
part 'merchant_category.g.dart';

@Freezed()
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String categoryName,
    required String imageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
