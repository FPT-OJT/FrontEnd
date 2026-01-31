import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant.dart';

@immutable
class MerchantAgency extends Equatable {
  const MerchantAgency({
    required this.id,
    required this.name,
    required this.merchant,
    required this.merchantId,
    required this.discount,
    required this.location,
    required this.imageUrl,
  });
  final String id;
  final String name;
  final Merchant merchant;
  final String merchantId;
  final Coordinate location;
  final double discount;
  final String imageUrl;
  @override
  List<Object?> get props => [
    id,
    name,
    merchant,
    merchantId,
    imageUrl,
    location,
  ];
}
