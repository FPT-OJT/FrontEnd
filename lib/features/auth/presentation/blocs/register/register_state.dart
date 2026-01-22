import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';

class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitting extends RegisterState {
  const RegisterSubmitting();
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess({required this.user});
  final User user;

  @override
  List<Object?> get props => [user];
}

class RegisterFailure extends RegisterState {
  const RegisterFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
