import 'package:flutter/widgets.dart';
import 'package:fpt_ojt/core/entity/base_entity.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_category.dart';

@immutable
class Merchant extends BaseEntity {
  const Merchant({
    required super.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required super.createdAt,
    required super.updatedAt,
    required this.category,
    required this.categoryId,
  });
  final String name;
  final String description;
  final String logoUrl;
  final MerchantCategory category;
  final String categoryId;
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    logoUrl,
    category,
    categoryId,
  ];
}
