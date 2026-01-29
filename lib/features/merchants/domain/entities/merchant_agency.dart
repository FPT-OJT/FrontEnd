import 'package:flutter/widgets.dart';
import 'package:fpt_ojt/core/entity/base_entity.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant.dart';

@immutable
class MerchantAgency extends BaseEntity {
  const MerchantAgency({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.name,
    required this.merchant,
    required this.merchantId,
    required this.longitude,
    required this.latitude,
    required this.imageUrl,
  });
  final String name;
  final Merchant merchant;
  final String merchantId;
  final double longitude;
  final double latitude;
  final String imageUrl;
  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    name,
    merchant,
    merchantId,
    longitude,
    latitude,
    imageUrl,
  ];
}
