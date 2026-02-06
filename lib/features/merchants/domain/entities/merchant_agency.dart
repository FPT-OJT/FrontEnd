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
    this.distance,
  });
  final String id;
  final String name;
  final Merchant merchant;
  final String merchantId;
  final Coordinate location;
  final double? distance;
  final double discount;
  final String imageUrl;

  MerchantAgency copyWith({
    String? id,
    String? name,
    Merchant? merchant,
    String? merchantId,
    Coordinate? location,
    double? distance,
    double? discount,
    String? imageUrl,
  }) => MerchantAgency(
    id: id ?? this.id,
    name: name ?? this.name,
    merchant: merchant ?? this.merchant,
    merchantId: merchantId ?? this.merchantId,
    location: location ?? this.location,
    distance: distance ?? this.distance,
    discount: discount ?? this.discount,
    imageUrl: imageUrl ?? this.imageUrl,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    merchant,
    merchantId,
    imageUrl,
    location,
    distance,
  ];
}
