import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.email,
  });
  final String id;
  final String name;
  final String avatar;
  final String email;
  @override
  List<Object?> get props => [id, name, avatar, email];
}
