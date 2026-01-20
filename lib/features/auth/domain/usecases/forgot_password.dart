import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  ForgotPasswordUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;
  final AuthRepository _authRepository;
  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async =>
      _authRepository.forgotPassword(params.email);
}

class ForgotPasswordParams {
  ForgotPasswordParams({required this.email});
  final String email;
}