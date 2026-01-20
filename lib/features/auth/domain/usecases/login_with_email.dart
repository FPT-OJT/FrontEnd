import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';

class LoginWithEmailUseCase implements UseCase<User, LoginWithEmailParams> {
  LoginWithEmailUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;
  final AuthRepository _authRepository;
  @override
  Future<Either<Failure, User>> call(LoginWithEmailParams params) async =>
      _authRepository.loginWithEmail(params.email, params.password);
}

class LoginWithEmailParams {
  LoginWithEmailParams({required this.email, required this.password});
  final String email;
  final String password;
}
