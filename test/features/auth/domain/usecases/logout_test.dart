import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/logout.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
import 'logout_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late LogoutUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LogoutUseCase(authRepository: mockAuthRepository);
    provideDummy<Either<Failure, void>>(const Right(null));
  });

  test('should call logout from repository', () async {
    // Arrange
    when(
      mockAuthRepository.logout(),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await useCase.call(NoParams());

    // Assert
    expect(result, const Right(null));
    verify(mockAuthRepository.logout()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
