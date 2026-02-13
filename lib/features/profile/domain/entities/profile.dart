import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String countryCode;
  final String phoneNumber;
  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    countryCode,
    phoneNumber,
  ];
}
