import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';

class ResetPasswordUseCase implements UseCase<void, ResetPasswordParams> {
  ResetPasswordUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;
  final AuthRepository _authRepository;
  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async =>
      _authRepository.resetPassword(params.email, params.otp, params.newPassword);
}

class ResetPasswordParams {
  ResetPasswordParams({required this.email, required this.otp, required this.newPassword});
  final String email;
  final String otp;
  final String newPassword;
}