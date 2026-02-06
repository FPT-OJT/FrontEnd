import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/intro/domain/entities/onboarding_item.dart';
import 'package:fpt_ojt/features/intro/domain/usecases/end_onboarding.dart';
import 'package:fpt_ojt/features/intro/domain/usecases/get_onboarding_completion_status.dart';
import 'package:fpt_ojt/features/intro/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:fpt_ojt/features/intro/presentation/blocs/onboarding/onboarding_state.dart';
import 'package:fpt_ojt/features/intro/presentation/constants/onboarding_constants.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<EndOnboardingUseCase>(),
  MockSpec<GetOnboardingCompletionStatusUseCase>(),
])
import 'onboarding_cubit_test.mocks.dart';

void main() {
  late MockEndOnboardingUseCase mockEndOnboardingUseCase;
  late MockGetOnboardingCompletionStatusUseCase mockGetIsOnboardingUseCase;
  const onboardingItems = OnboardingConstants.onboardingItems;
  setUpAll(() {
    // Provide dummy values for Mockito
    provideDummy<Either<Failure, bool>>(const Right(false));
    provideDummy<Either<Failure, Unit>>(const Right(unit));
  });

  setUp(() {
    mockEndOnboardingUseCase = MockEndOnboardingUseCase();
    mockGetIsOnboardingUseCase = MockGetOnboardingCompletionStatusUseCase();

    // Reset mocks to clear any previous stubs
    reset(mockEndOnboardingUseCase);
    reset(mockGetIsOnboardingUseCase);
  });

  group('OnboardingCubit', () {
    test('initial state should be OnboardingInitial', () {
      // Arrange
      final cubit = OnboardingCubit(
        endOnboardingUseCase: mockEndOnboardingUseCase,
        getIsOnboardingUseCase: mockGetIsOnboardingUseCase,
      );

      // Assert
      expect(cubit.state, const OnboardingInitial());

      cubit.close();
    });

    group('initialize', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'emits [OnboardingLoading, OnboardingCompleted] when already completed',
        build: () {
          when(
            mockGetIsOnboardingUseCase.call(any),
          ).thenAnswer((_) async => const Right(true));
          return OnboardingCubit(
            endOnboardingUseCase: mockEndOnboardingUseCase,
            getIsOnboardingUseCase: mockGetIsOnboardingUseCase,
          );
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [const OnboardingLoading(), const OnboardingCompleted()],
        verify: (_) {
          verify(mockGetIsOnboardingUseCase.call(any)).called(1);
        },
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits [OnboardingLoading, OnboardingSession] when not completed',
        build: () {
          when(
            mockGetIsOnboardingUseCase.call(any),
          ).thenAnswer((_) async => const Right(false));
          return OnboardingCubit(
            endOnboardingUseCase: mockEndOnboardingUseCase,
            getIsOnboardingUseCase: mockGetIsOnboardingUseCase,
          );
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const OnboardingLoading(),
          const OnboardingSession(0, onboardingItems),
        ],
        verify: (_) {
          verify(mockGetIsOnboardingUseCase.call(any)).called(1);
        },
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits [OnboardingLoading, OnboardingError] when initialization fails',
        build: () {
          when(
            mockGetIsOnboardingUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Storage error')));
          return OnboardingCubit(
            endOnboardingUseCase: mockEndOnboardingUseCase,
            getIsOnboardingUseCase: mockGetIsOnboardingUseCase,
          );
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const OnboardingLoading(),
          const OnboardingError('Storage error'),
        ],
        verify: (_) {
          verify(mockGetIsOnboardingUseCase.call(any)).called(1);
        },
      );
    });

    group('pageChanged', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'updates page when pageChanged is called',
        build: () => OnboardingCubit(
          endOnboardingUseCase: mockEndOnboardingUseCase,
          getIsOnboardingUseCase: mockGetIsOnboardingUseCase,
        ),
        seed: () => const OnboardingSession(0, onboardingItems),
        act: (cubit) => cubit.pageChanged(1.5),
        expect: () => [const OnboardingSession(1.5, onboardingItems)],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'updates page to last page',
        build: () => OnboardingCubit(
          endOnboardingUseCase: mockEndOnboardingUseCase,
          getIsOnboardingUseCase: mockGetIsOnboardingUseCase,
        ),
        seed: () => const OnboardingSession(0, onboardingItems),
        act: (cubit) => cubit.pageChanged(2),
        expect: () => [const OnboardingSession(2, onboardingItems)],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'updates page multiple times',
        build: () => OnboardingCubit(
          endOnboardingUseCase: mockEndOnboardingUseCase,
          getIsOnboardingUseCase: mockGetIsOnboardingUseCase,
        ),
        seed: () => const OnboardingSession(0, onboardingItems),
        act: (cubit) async {
          cubit.pageChanged(0.5);
          await Future.delayed(const Duration(milliseconds: 10));
          cubit.pageChanged(1);
          await Future.delayed(const Duration(milliseconds: 10));
          cubit.pageChanged(1.5);
        },
        expect: () => [
          const OnboardingSession(0.5, onboardingItems),
          const OnboardingSession(1, onboardingItems),
          const OnboardingSession(1.5, onboardingItems),
        ],
      );
    });

    group('complete', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'emits [OnboardingCompleted] when complete succeeds',
        build: () {
          when(
            mockEndOnboardingUseCase.call(any),
          ).thenAnswer((_) async => const Right(unit));
          return OnboardingCubit(
            endOnboardingUseCase: mockEndOnboardingUseCase,
            getIsOnboardingUseCase: mockGetIsOnboardingUseCase,
          );
        },
        act: (cubit) => cubit.complete(),
        expect: () => [const OnboardingCompleted()],
        verify: (_) {
          verify(mockEndOnboardingUseCase.call(any)).called(1);
        },
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits [OnboardingError] when complete fails',
        build: () {
          when(
            mockEndOnboardingUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Save failed')));
          return OnboardingCubit(
            endOnboardingUseCase: mockEndOnboardingUseCase,
            getIsOnboardingUseCase: mockGetIsOnboardingUseCase,
          );
        },
        act: (cubit) => cubit.complete(),
        expect: () => [const OnboardingError('Save failed')],
        verify: (_) {
          verify(mockEndOnboardingUseCase.call(any)).called(1);
        },
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits [OnboardingError] when storage throws exception',
        build: () {
          when(mockEndOnboardingUseCase.call(any)).thenAnswer(
            (_) async => Left(Failure('Unable to save onboarding status')),
          );
          return OnboardingCubit(
            endOnboardingUseCase: mockEndOnboardingUseCase,
            getIsOnboardingUseCase: mockGetIsOnboardingUseCase,
          );
        },
        act: (cubit) => cubit.complete(),
        expect: () => [
          const OnboardingError('Unable to save onboarding status'),
        ],
      );
    });
  });

  group('OnboardingSession state properties', () {
    test('isLast returns true when on last page', () {
      // Arrange
      final state = OnboardingSession(
        (onboardingItems.length - 1).toDouble(),
        onboardingItems,
      );

      // Assert
      expect(state.isLast, true);
    });

    test('isLast returns true when page is beyond last page', () {
      // Arrange
      final state = OnboardingSession(
        onboardingItems.length.toDouble(),
        onboardingItems,
      );

      // Assert
      expect(state.isLast, true);
    });

    test('isLast returns false when not on last page', () {
      // Arrange
      const state = OnboardingSession(0, onboardingItems);

      // Assert
      expect(state.isLast, false);
    });

    test('isLast returns false when on middle page', () {
      // Arrange
      const state = OnboardingSession(1, onboardingItems);

      // Assert
      expect(state.isLast, false);
    });

    test('isFirst returns true when on first page', () {
      // Arrange
      const state = OnboardingSession(0, onboardingItems);

      // Assert
      expect(state.isFirst, true);
    });

    test('isFirst returns true when page is negative', () {
      // Arrange
      const state = OnboardingSession(-0.5, onboardingItems);

      // Assert
      expect(state.isFirst, true);
    });

    test('isFirst returns false when not on first page', () {
      // Arrange
      const state = OnboardingSession(1, onboardingItems);

      // Assert
      expect(state.isFirst, false);
    });

    test('currentIndex returns correct rounded index', () {
      // Arrange
      const state = OnboardingSession(1.6, onboardingItems);

      // Assert
      expect(state.currentIndex, 2);
    });

    test('currentIndex returns 0 for first page', () {
      // Arrange
      const state = OnboardingSession(0, onboardingItems);

      // Assert
      expect(state.currentIndex, 0);
    });

    test('currentIndex returns correct index when page is 0.4', () {
      // Arrange
      const state = OnboardingSession(0.4, onboardingItems);

      // Assert
      expect(state.currentIndex, 0);
    });

    test('currentIndex returns correct index when page is 0.5', () {
      // Arrange
      const state = OnboardingSession(0.5, onboardingItems);

      // Assert
      expect(state.currentIndex, 1);
    });

    test('currentIndex clamps to max index when page exceeds length', () {
      // Arrange
      final state = OnboardingSession(
        onboardingItems.length.toDouble() + 5,
        onboardingItems,
      );

      // Assert
      expect(state.currentIndex, onboardingItems.length - 1);
    });

    test('currentIndex clamps to 0 when page is negative', () {
      // Arrange
      const state = OnboardingSession(-2, onboardingItems);

      // Assert
      expect(state.currentIndex, 0);
    });

    test('currentItem returns correct item', () {
      // Arrange
      const state = OnboardingSession(1, onboardingItems);

      // Assert
      expect(state.currentItem, onboardingItems[1]);
    });

    test('currentItem returns first item when on first page', () {
      // Arrange
      const state = OnboardingSession(0, onboardingItems);

      // Assert
      expect(state.currentItem, onboardingItems[0]);
    });

    test('currentItem returns last item when on last page', () {
      // Arrange
      final state = OnboardingSession(
        (onboardingItems.length - 1).toDouble(),
        onboardingItems,
      );

      // Assert
      expect(state.currentItem, onboardingItems[onboardingItems.length - 1]);
    });

    test('copyWith creates new instance with updated page', () {
      // Arrange
      const state = OnboardingSession(0, onboardingItems);

      // Act
      final newState = state.copyWith(page: 1.5);

      // Assert
      expect(newState.page, 1.5);
      expect(newState.items, onboardingItems);
      expect(state.page, 0.0); // Original unchanged
    });

    test('copyWith creates new instance with updated items', () {
      // Arrange
      const state = OnboardingSession(0, onboardingItems);
      const newItems = <OnboardingItem>[];

      // Act
      final newState = state.copyWith(items: newItems);

      // Assert
      expect(newState.page, 0.0);
      expect(newState.items, newItems);
      expect(state.items, onboardingItems); // Original unchanged
    });

    test('copyWith creates new instance with both updated', () {
      // Arrange
      const state = OnboardingSession(0, onboardingItems);
      const newItems = <OnboardingItem>[];

      // Act
      final newState = state.copyWith(page: 2, items: newItems);

      // Assert
      expect(newState.page, 2.0);
      expect(newState.items, newItems);
    });

    test('copyWith without parameters returns copy with same values', () {
      // Arrange
      const state = OnboardingSession(1.5, onboardingItems);

      // Act
      final newState = state.copyWith();

      // Assert
      expect(newState.page, 1.5);
      expect(newState.items, onboardingItems);
    });
  });

  group('OnboardingState equality', () {
    test('OnboardingInitial instances are equal', () {
      // Arrange
      const state1 = OnboardingInitial();
      const state2 = OnboardingInitial();

      // Assert
      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('OnboardingLoading instances are equal', () {
      // Arrange
      const state1 = OnboardingLoading();
      const state2 = OnboardingLoading();

      // Assert
      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('OnboardingCompleted instances are equal', () {
      // Arrange
      const state1 = OnboardingCompleted();
      const state2 = OnboardingCompleted();

      // Assert
      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('OnboardingError with same message are equal', () {
      // Arrange
      const state1 = OnboardingError('Error message');
      const state2 = OnboardingError('Error message');

      // Assert
      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('OnboardingError with different messages are not equal', () {
      // Arrange
      const state1 = OnboardingError('Error 1');
      const state2 = OnboardingError('Error 2');

      // Assert
      expect(state1, isNot(equals(state2)));
    });

    test('OnboardingSession with same page and items are equal', () {
      // Arrange
      const state1 = OnboardingSession(1.5, onboardingItems);
      const state2 = OnboardingSession(1.5, onboardingItems);

      // Assert
      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('OnboardingSession with different page are not equal', () {
      // Arrange
      const state1 = OnboardingSession(1.5, onboardingItems);
      const state2 = OnboardingSession(2, onboardingItems);

      // Assert
      expect(state1, isNot(equals(state2)));
    });

    test('OnboardingSession with different items are not equal', () {
      // Arrange
      const state1 = OnboardingSession(1.5, onboardingItems);
      const state2 = OnboardingSession(1.5, <OnboardingItem>[]);

      // Assert
      expect(state1, isNot(equals(state2)));
    });

    test('different state types are not equal', () {
      // Arrange
      const state1 = OnboardingInitial();
      const state2 = OnboardingLoading();
      const state3 = OnboardingCompleted();
      const state4 = OnboardingError('Error');
      const state5 = OnboardingSession(0, onboardingItems);

      // Assert
      expect(state1, isNot(equals(state2)));
      expect(state1, isNot(equals(state3)));
      expect(state1, isNot(equals(state4)));
      expect(state1, isNot(equals(state5)));
      expect(state2, isNot(equals(state3)));
      expect(state2, isNot(equals(state4)));
      expect(state2, isNot(equals(state5)));
      expect(state3, isNot(equals(state4)));
      expect(state3, isNot(equals(state5)));
      expect(state4, isNot(equals(state5)));
    });
  });
}
