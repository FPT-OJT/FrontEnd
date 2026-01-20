import 'package:equatable/equatable.dart';

class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.repeatPassword,
  });

  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final String repeatPassword;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    username,
    password,
    repeatPassword,
  ];
}
