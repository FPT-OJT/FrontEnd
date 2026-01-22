import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  LogoutUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;
  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async =>
      _authRepository.logout();
}
