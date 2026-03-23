import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/register.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
import 'register_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late RegisterUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = RegisterUseCase(authRepository: mockAuthRepository);
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

  const firstName = 'Test';
  const lastName = 'User';
  const username = 'testuser';
  const email = 'test@example.com';
  const password = 'password';
  const repeatPassword = 'password';

  test('should call register from repository', () async {
    // Arrange
    when(
      mockAuthRepository.register(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password: password,
        repeatPassword: repeatPassword,
      ),
    ).thenAnswer((_) async => Right(testUser));

    // Act
    final result = await useCase.call(
      const RegisterParams(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password: password,
        repeatPassword: repeatPassword,
      ),
    );

    // Assert
    expect(result, Right(testUser));
    verify(
      mockAuthRepository.register(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password: password,
        repeatPassword: repeatPassword,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
