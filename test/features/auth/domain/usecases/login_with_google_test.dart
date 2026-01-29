import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/login_with_google.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
import 'login_with_google_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginWithGoogleUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LoginWithGoogleUseCase(authRepository: mockAuthRepository);
    provideDummy<Either<Failure, User>>(
      Right(
        User(
          id: '1',
          name: 'Dummy User',
          email: 'dummy@example.com',
          avatar: 'avatar.png',
        ),
      ),
    );
  });

  final testUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    avatar: 'avatar.png',
  );

  test('should call loginWithGoogle from repository', () async {
    // Arrange
    when(
      mockAuthRepository.loginWithGoogle(),
    ).thenAnswer((_) async => Right(testUser));

    // Act
    final result = await useCase.call(NoParams());

    // Assert
    expect(result, Right(testUser));
    verify(mockAuthRepository.loginWithGoogle()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
