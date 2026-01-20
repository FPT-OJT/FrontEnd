import 'package:equatable/equatable.dart';

class LoginDetailsEvent extends Equatable {
  const LoginDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginDetailsEvent {
  const LoginSubmitted({required this.email, required this.password});
  final String email;
  final String password;
  @override
  List<Object?> get props => [email, password];
}
