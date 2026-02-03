import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';

@immutable
class MerchantOffer extends Equatable {
  const MerchantOffer({
    this.merchantAgencyId,
    this.merchantAgencyName,
    this.merchantDealName,
    this.imageUrl,
    this.totalDiscount,
    this.favorite,
    this.location,
    this.subscribed,
    this.distance,
  });
  final String? merchantAgencyId;
  final String? merchantAgencyName;
  final String? merchantDealName;
  final String? imageUrl;
  final double? totalDiscount;
  final bool? favorite;
  final Coordinate? location;
  final bool? subscribed;
  final double? distance;

  @override
  List<Object?> get props => [
    merchantAgencyId,
    merchantAgencyName,
    merchantDealName,
    imageUrl,
    totalDiscount,
    favorite,
    subscribed,
    location,
    distance,
  ];
}
