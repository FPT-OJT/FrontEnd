import 'package:equatable/equatable.dart';

class LoginDetailsEvent extends Equatable {
  const LoginDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginDetailsEvent {
  const LoginSubmitted({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
  final String email;
  final String password;
  final bool rememberMe;
  @override
  List<Object?> get props => [email, password];
}
