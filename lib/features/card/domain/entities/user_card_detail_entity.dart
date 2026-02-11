import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UserCardDetailEntity extends Equatable {
  const UserCardDetailEntity({
    required this.userCardId,
    required this.cardName,
    required this.cardType,
    this.cardImageUrl,
    this.firstPaymentDate,
    this.expiryDate,
  });

  final String userCardId;
  final String cardName;
  final String cardType;
  final String? cardImageUrl;
  final int? firstPaymentDate;
  final DateTime? expiryDate;

  @override
  List<Object?> get props => [
    userCardId,
    cardName,
    cardType,
    cardImageUrl,
    firstPaymentDate,
    expiryDate,
  ];
}
