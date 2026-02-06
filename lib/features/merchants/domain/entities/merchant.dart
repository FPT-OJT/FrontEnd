import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class Merchant extends Equatable {
  const Merchant({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
  });
  final String id;
  final String name;
  final String description;
  final String logoUrl;

  @override
  List<Object?> get props => [id, name, description, logoUrl];
}
