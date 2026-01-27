import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/features/intro/data/datasources/onboarding_datasource.dart';
import 'package:fpt_ojt/features/intro/data/repository/onboarding_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<OnboardingDataSource>()])
import 'onboarding_repository_impl_test.mocks.dart';

void main() {
  late MockOnboardingDataSource mockDataSource;
  late OnboardingRepositoryImpl repository;

  setUpAll(() {
    // Provide dummy values for Mockito
    provideDummy<Either<Object, Unit>>(const Right(unit));
  });

  setUp(() {
    mockDataSource = MockOnboardingDataSource();
    repository = OnboardingRepositoryImpl(mockDataSource);

    // Reset mocks to clear any previous stubs
    reset(mockDataSource);
  });

  group('OnboardingRepositoryImpl', () {
    group('isSeen', () {
      test('should return true when datasource returns true', () async {
        // Arrange
        when(mockDataSource.isSeen()).thenAnswer((_) async => true);

        // Act
        final result = await repository.isSeen();

        // Assert
        expect(result, true);
        verify(mockDataSource.isSeen()).called(1);
      });

      test('should return false when datasource returns false', () async {
        // Arrange
        when(mockDataSource.isSeen()).thenAnswer((_) async => false);

        // Act
        final result = await repository.isSeen();

        // Assert
        expect(result, false);
        verify(mockDataSource.isSeen()).called(1);
      });

      test('should call datasource isSeen exactly once', () async {
        // Arrange
        when(mockDataSource.isSeen()).thenAnswer((_) async => true);

        // Act
        await repository.isSeen();

        // Assert
        verify(mockDataSource.isSeen()).called(1);
        verifyNoMoreInteractions(mockDataSource);
      });

      test('should propagate exception when datasource throws', () async {
        // Arrange
        when(mockDataSource.isSeen()).thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(() => repository.isSeen(), throwsA(isA<Exception>()));
      });
    });

    group('setSeen', () {
      test('should return Right(unit) when datasource succeeds', () async {
        // Arrange
        when(mockDataSource.setSeen()).thenAnswer((_) async => {});

        // Act
        final result = await repository.setSeen();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return Right'),
          (value) => expect(value, unit),
        );
        verify(mockDataSource.setSeen()).called(1);
      });

      test('should call datasource setSeen exactly once on success', () async {
        // Arrange
        when(mockDataSource.setSeen()).thenAnswer((_) async => {});

        // Act
        await repository.setSeen();

        // Assert
        verify(mockDataSource.setSeen()).called(1);
        verifyNoMoreInteractions(mockDataSource);
      });

      test(
        'should return Left(Failure) when datasource throws exception',
        () async {
          // Arrange
          when(mockDataSource.setSeen()).thenThrow(Exception('Storage error'));

          // Act
          final result = await repository.setSeen();

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure.message, contains('Storage error'));
          }, (value) => fail('Should return Left'));
          verify(mockDataSource.setSeen()).called(1);
        },
      );

      test(
        'should return Left with exception message when datasource fails',
        () async {
          // Arrange
          const errorMessage = 'Unable to write to storage';
          when(mockDataSource.setSeen()).thenThrow(Exception(errorMessage));

          // Act
          final result = await repository.setSeen();

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure.message, contains(errorMessage));
          }, (_) => fail('Should return Left'));
        },
      );

      test(
        'should handle multiple exceptions with different messages',
        () async {
          // Arrange - First call throws error
          when(mockDataSource.setSeen()).thenThrow(Exception('First error'));

          // Act
          final result1 = await repository.setSeen();

          // Assert first call
          expect(result1.isLeft(), true);
          result1.fold(
            (failure) => expect(failure.message, contains('First error')),
            (_) => fail('Should return Left'),
          );

          // Arrange - Second call with different error
          reset(mockDataSource);
          when(mockDataSource.setSeen()).thenThrow(Exception('Second error'));

          // Act
          final result2 = await repository.setSeen();

          // Assert second call
          expect(result2.isLeft(), true);
          result2.fold(
            (failure) => expect(failure.message, contains('Second error')),
            (_) => fail('Should return Left'),
          );
        },
      );

      test(
        'should not call datasource multiple times on single call',
        () async {
          // Arrange
          when(mockDataSource.setSeen()).thenAnswer((_) async => {});

          // Act
          await repository.setSeen();

          // Assert - Should be called exactly once
          verify(mockDataSource.setSeen()).called(1);
        },
      );
    });

    group('integration scenarios', () {
      test('should handle checking and setting seen status', () async {
        // Arrange - Initially not seen
        when(mockDataSource.isSeen()).thenAnswer((_) async => false);

        // Act - Check initial status
        var seen = await repository.isSeen();

        // Assert - Should be false initially
        expect(seen, false);

        // Arrange - Set as seen
        when(mockDataSource.setSeen()).thenAnswer((_) async => {});
        when(mockDataSource.isSeen()).thenAnswer((_) async => true);

        // Act - Mark as seen
        final setResult = await repository.setSeen();

        // Assert - Should succeed
        expect(setResult.isRight(), true);

        // Act - Check status again
        seen = await repository.isSeen();

        // Assert - Should now be true
        expect(seen, true);
      });

      test('should handle multiple isSeen calls', () async {
        // Arrange
        when(mockDataSource.isSeen()).thenAnswer((_) async => true);

        // Act - Call multiple times
        final result1 = await repository.isSeen();
        final result2 = await repository.isSeen();
        final result3 = await repository.isSeen();

        // Assert
        expect(result1, true);
        expect(result2, true);
        expect(result3, true);
        verify(mockDataSource.isSeen()).called(3);
      });

      test('should handle multiple setSeen calls', () async {
        // Arrange
        when(mockDataSource.setSeen()).thenAnswer((_) async => {});

        // Act - Call multiple times
        final result1 = await repository.setSeen();
        final result2 = await repository.setSeen();

        // Assert - All should succeed
        expect(result1.isRight(), true);
        expect(result2.isRight(), true);
        verify(mockDataSource.setSeen()).called(2);
      });

      test('should handle alternating success and failure', () async {
        // Arrange - First call succeeds
        when(mockDataSource.setSeen()).thenAnswer((_) async => {});

        // Act & Assert - First call
        var result = await repository.setSeen();
        expect(result.isRight(), true);

        // Arrange - Second call fails
        reset(mockDataSource);
        when(mockDataSource.setSeen()).thenThrow(Exception('Error'));

        // Act & Assert - Second call
        result = await repository.setSeen();
        expect(result.isLeft(), true);

        // Arrange - Third call succeeds again
        reset(mockDataSource);
        when(mockDataSource.setSeen()).thenAnswer((_) async => {});

        // Act & Assert - Third call
        result = await repository.setSeen();
        expect(result.isRight(), true);
      });
    });

    group('edge cases', () {
      test('should handle Future.delayed in datasource', () async {
        // Arrange - Simulate slow storage
        when(mockDataSource.setSeen()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
        });

        // Act
        final result = await repository.setSeen();

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle immediate datasource response', () async {
        // Arrange
        when(mockDataSource.isSeen()).thenAnswer((_) async => true);

        // Act
        final result = await repository.isSeen();

        // Assert
        expect(result, true);
      });

      test('should handle generic Exception type', () async {
        // Arrange
        when(mockDataSource.setSeen()).thenThrow(Exception());

        // Act
        final result = await repository.setSeen();

        // Assert
        expect(result.isLeft(), true);
      });

      test('should handle exception with empty message', () async {
        // Arrange
        when(mockDataSource.setSeen()).thenThrow(Exception(''));

        // Act
        final result = await repository.setSeen();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, isNotNull),
          (_) => fail('Should return Left'),
        );
      });

      test('should handle exception with special characters', () async {
        // Arrange
        const specialMessage = 'Error: Storage\$#@! failed\n\t';
        when(mockDataSource.setSeen()).thenThrow(Exception(specialMessage));

        // Act
        final result = await repository.setSeen();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains(specialMessage)),
          (_) => fail('Should return Left'),
        );
      });
    });
  });
}
