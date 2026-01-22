import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  const AuthLoading();
  @override
  List<Object?> get props => [];
}

class AuthLoggedIn extends AuthState {
  const AuthLoggedIn({required this.user});
  final User user;
  @override
  List<Object?> get props => [user];
}

class AuthUnAuthenticated extends AuthState {
  const AuthUnAuthenticated();
  @override
  List<Object?> get props => [];
}

class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
  @override
  List<Object?> get props => [];
}

class AuthFailure extends AuthState {
  const AuthFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
