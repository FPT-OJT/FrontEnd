import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class Card extends Equatable {
  const Card({
    required this.imageUrl,
    required this.name,
    required this.productId,
    required this.type,
    required this.deals,
  });

  final String imageUrl;
  final String name;
  final String productId;
  final String type;
  final List<CardDeal> deals;

  double get maxReduceRate => deals.fold(
    0,
    (m, deal) => deal.maxReduceRate > m ? deal.maxReduceRate : m,
  );
  @override
  List<Object?> get props => [imageUrl, name, productId, type, deals];
}

enum CardDealType { merchantDeal, cardDeal }

@immutable
class CardDeal extends Equatable {
  const CardDeal({
    this.cashbackRate,
    this.dealId,
    this.dealName,
    this.description,
    this.discountRate,
    this.pointsMultiplier,
    this.type = CardDealType.merchantDeal,
    this.validFrom,
    this.validTo,
  });
  final double? cashbackRate;
  final String? dealId;
  final String? dealName;
  final String? description;
  final double? discountRate;
  final double? pointsMultiplier;
  final CardDealType type;
  final DateTime? validFrom;
  final DateTime? validTo;

  double get maxReduceRate => max(discountRate ?? 0, cashbackRate ?? 0);

  @override
  List<Object?> get props => [
    cashbackRate,
    dealId,
    dealName,
    description,
    discountRate,
    pointsMultiplier,
    type,
    validFrom,
    validTo,
  ];
}
