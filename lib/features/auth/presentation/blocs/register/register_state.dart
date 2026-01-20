import 'package:equatable/equatable.dart';

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
  const RegisterSuccess();

  @override
  List<Object?> get props => [];
}

class RegisterFailure extends RegisterState {
  const RegisterFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
