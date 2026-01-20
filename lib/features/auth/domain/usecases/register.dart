import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';

class RegisterUseCase implements UseCase<Unit, RegisterParams> {
  RegisterUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;
  final AuthRepository _authRepository;
  @override
  Future<Either<Failure, Unit>> call(RegisterParams params) async {
    final result = await _authRepository.register(
      firstName: params.firstName,
      lastName: params.lastName,
      username: params.username,
      password: params.password,
      repeatPassword: params.repeatPassword,
    );
    return result.fold(Left.new, (ok) => const Right(unit));
  }
}

class RegisterParams {
  RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.repeatPassword,
  });
  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final String repeatPassword;
}
