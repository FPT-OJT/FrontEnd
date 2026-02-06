import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/forgot_password.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
import 'forgot_password_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late ForgotPasswordUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = ForgotPasswordUseCase(authRepository: mockAuthRepository);
    provideDummy<Either<Failure, void>>(const Right(null));
  });

  const email = 'test@example.com';

  test('should call forgotPassword from repository', () async {
    // Arrange
    when(
      mockAuthRepository.forgotPassword(email),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await useCase.call(const ForgotPasswordParams(email: email));

    // Assert
    expect(result, const Right(null));
    verify(mockAuthRepository.forgotPassword(email)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
