import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';

class LoginOptionsState extends Equatable {
  const LoginOptionsState();

  @override
  List<Object?> get props => [];
}

class LoginOptionsInitial extends LoginOptionsState {
  const LoginOptionsInitial();
  @override
  List<Object?> get props => [];
}

class LoginWithFacebookLoading extends LoginOptionsState {
  const LoginWithFacebookLoading();
  @override
  List<Object?> get props => [];
}

class LoginWithFacebookError extends LoginOptionsState {
  const LoginWithFacebookError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class LoginWithFacebookSuccess extends LoginOptionsState {
  const LoginWithFacebookSuccess();
  @override
  List<Object?> get props => [];
}

class LoginWithGoogleLoading extends LoginOptionsState {
  const LoginWithGoogleLoading();
  @override
  List<Object?> get props => [];
}

class LoginWithGoogleError extends LoginOptionsState {
  const LoginWithGoogleError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class LoginWithGoogleSuccess extends LoginOptionsState {
  const LoginWithGoogleSuccess({required this.user});
  final User user;
  @override
  List<Object?> get props => [];
}
