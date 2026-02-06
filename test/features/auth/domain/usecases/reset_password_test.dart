import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/reset_password.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
import 'reset_password_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late ResetPasswordUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = ResetPasswordUseCase(authRepository: mockAuthRepository);
    provideDummy<Either<Failure, void>>(const Right(null));
  });

  const email = 'test@example.com';
  const otpCode = '123456';
  const newPassword = 'newPassword';

  test('should call resetPassword from repository', () async {
    // Arrange
    when(
      mockAuthRepository.resetPassword(email, otpCode, newPassword),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await useCase.call(
      const ResetPasswordParams(
        email: email,
        otp: otpCode,
        newPassword: newPassword,
      ),
    );

    // Assert
    expect(result, const Right(null));
    verify(
      mockAuthRepository.resetPassword(email, otpCode, newPassword),
    ).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
