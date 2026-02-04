import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class MerchantCategory extends Equatable {
  const MerchantCategory({this.id, this.name, this.imageUrl});
  final String? id;
  final String? name;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, name, imageUrl];
}
