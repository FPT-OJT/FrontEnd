import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/login_with_email.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
import 'login_with_email_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginWithEmailUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LoginWithEmailUseCase(authRepository: mockAuthRepository);
    provideDummy<Either<Failure, User>>(
      Right(
        User(
          id: 'dummy',
          firstName: 'dummy',
          lastName: 'dummy',
          email: 'dummy@example.com',
          avatar: 'dummy.png',
        ),
      ),
    );
  });

  final testUser = User(
    id: '1',
    firstName: 'Test',
    lastName: 'User',
    email: 'test@example.com',
    avatar: 'avatar.png',
  );

  const email = 'test@example.com';
  const password = 'password';
  const rememberMe = true;

  test('should call loginWithEmail from repository', () async {
    // Arrange
    when(
      mockAuthRepository.loginWithEmail(
        email,
        password,
        rememberMe: rememberMe,
      ),
    ).thenAnswer((_) async => Right(testUser));

    // Act
    final result = await useCase.call(
      const LoginWithEmailParams(
        email: email,
        password: password,
        rememberMe: rememberMe,
      ),
    );

    // Assert
    expect(result, Right(testUser));
    verify(
      mockAuthRepository.loginWithEmail(
        email,
        password,
        rememberMe: rememberMe,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
