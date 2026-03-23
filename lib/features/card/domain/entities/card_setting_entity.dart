import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CardSettingEntity extends Equatable {
  const CardSettingEntity({
    required this.cardId,
    this.imageUrl,
    this.firstPaymentDate,
    this.expiryDate,
  });

  final String cardId;
  final String? imageUrl;
  final int? firstPaymentDate;
  final DateTime? expiryDate;

  @override
  List<Object?> get props => [cardId, imageUrl, firstPaymentDate, expiryDate];
}
