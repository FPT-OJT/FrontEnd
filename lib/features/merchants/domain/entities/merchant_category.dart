import 'package:flutter/widgets.dart';
import 'package:fpt_ojt/core/entity/base_entity.dart';

@immutable
class MerchantCategory extends BaseEntity {
  const MerchantCategory({
    required this.categoryName,
    required this.imageUrl,
    required super.id,
    required super.createdAt,
    required super.updatedAt,
  });
  final String categoryName;
  final String imageUrl;
  @override
  List<Object?> get props => [id, createdAt, updatedAt, categoryName, imageUrl];
}