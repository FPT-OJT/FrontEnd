import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';

class LoginDetailsState extends Equatable {
  const LoginDetailsState();

  @override
  List<Object?> get props => [];
}

class LoginDetailsInitial extends LoginDetailsState {
  const LoginDetailsInitial();
  @override
  List<Object?> get props => [];
}

class LoginSubmitting extends LoginDetailsState {
  const LoginSubmitting();
}

class LoginSuccess extends LoginDetailsState {
  const LoginSuccess({required this.user});
  final User user;
  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginDetailsState {
  const LoginFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
