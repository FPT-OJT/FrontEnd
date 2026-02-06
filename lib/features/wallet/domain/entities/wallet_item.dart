import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class WalletItem extends Equatable {
  const WalletItem({this.id, this.imageUrl});
  final String? id;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, imageUrl];
}
