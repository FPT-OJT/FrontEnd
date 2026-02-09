import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class User extends Equatable {
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.email,
  });
  final String id;
  final String firstName;
  final String lastName;
  final String avatar;
  final String email;
  @override
  List<Object?> get props => [id, firstName, lastName, avatar, email];
}
