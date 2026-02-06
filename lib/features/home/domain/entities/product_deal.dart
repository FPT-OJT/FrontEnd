import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ProductDeal extends Equatable {
  const ProductDeal({
    this.name,
    this.imageUrl,
    this.originalPrice,
    this.discountedPrice,
    this.discountPercentage,
  });
  final String? name;
  final String? imageUrl;
  final double? originalPrice;
  final double? discountedPrice;
  final double? discountPercentage;

  @override
  List<Object?> get props => [
    name,
    imageUrl,
    originalPrice,
    discountedPrice,
    discountPercentage,
  ];
}
