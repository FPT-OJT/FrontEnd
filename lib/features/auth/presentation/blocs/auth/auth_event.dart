import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthIsUserLoggedInEvent extends AuthEvent {
  const AuthIsUserLoggedInEvent();
  @override
  List<Object?> get props => [];
}

class AuthLoggedOutEvent extends AuthEvent {
  const AuthLoggedOutEvent();
  @override
  List<Object?> get props => [];
}

class AuthLoggedInEvent extends AuthEvent {
  const AuthLoggedInEvent({required this.user});
  final User user;
  @override
  List<Object?> get props => [user];
}

class AuthUpdateUserEvent extends AuthEvent {
  const AuthUpdateUserEvent({required this.user});
  final User user;
  @override
  List<Object?> get props => [user];
}
