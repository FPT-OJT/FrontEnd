import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {
  RegisterUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;
  final AuthRepository _authRepository;
  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    final result = await _authRepository.register(
      firstName: params.firstName,
      lastName: params.lastName,
      username: params.username,
      password: params.password,
      repeatPassword: params.repeatPassword,
      email: params.email,
    );
    return result.fold(Left.new, Right.new);
  }
}
@immutable
class RegisterParams extends Equatable {
  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    required this.repeatPassword,
  });
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final String repeatPassword;
  @override
  List<Object?> get props => [firstName, lastName, username, email, password, repeatPassword];
}
