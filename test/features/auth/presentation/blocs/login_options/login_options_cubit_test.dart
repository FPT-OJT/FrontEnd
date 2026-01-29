import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/login_with_google.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_options/login_options_cubit.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_options/login_options_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<LoginWithGoogleUseCase>()])
import 'login_options_cubit_test.mocks.dart';

void main() {
  late MockLoginWithGoogleUseCase mockLoginWithGoogleUseCase;
  late LoginOptionsCubit cubit;

  setUpAll(() {
    // Provide dummy values for Either types
    provideDummy<Either<Failure, User>>(
      const Right(User(id: '', name: '', email: '', avatar: '')),
    );
  });

  setUp(() {
    mockLoginWithGoogleUseCase = MockLoginWithGoogleUseCase();
    cubit = LoginOptionsCubit(
      loginWithGoogleUseCase: mockLoginWithGoogleUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('LoginOptionsCubit', () {
    const testUser = User(
      id: '1',
      name: 'Test User',
      email: 'test@test.com',
      avatar: 'https://example.com/avatar.png',
    );

    test('initial state should be LoginOptionsInitial', () {
      expect(cubit.state, const LoginOptionsInitial());
    });

    group('loginWithGoogle', () {
      blocTest<LoginOptionsCubit, LoginOptionsState>(
        'emits [LoginWithGoogleLoading, LoginWithGoogleSuccess] when login succeeds',
        build: () {
          when(
            mockLoginWithGoogleUseCase.call(const NoParams()),
          ).thenAnswer((_) async => const Right(testUser));
          return cubit;
        },
        act: (cubit) => cubit.loginWithGoogle(),
        expect: () => [
          const LoginWithGoogleLoading(),
          const LoginWithGoogleSuccess(user: testUser),
        ],
        verify: (_) {
          verify(mockLoginWithGoogleUseCase.call(const NoParams())).called(1);
        },
      );

      blocTest<LoginOptionsCubit, LoginOptionsState>(
        'emits [LoginWithGoogleLoading, LoginWithGoogleError] when login fails',
        build: () {
          when(
            mockLoginWithGoogleUseCase.call(const NoParams()),
          ).thenAnswer((_) async => Left(Failure('Google sign in failed')));
          return cubit;
        },
        act: (cubit) => cubit.loginWithGoogle(),
        expect: () => [
          const LoginWithGoogleLoading(),
          const LoginWithGoogleError('Google sign in failed'),
        ],
        verify: (_) {
          verify(mockLoginWithGoogleUseCase.call(const NoParams())).called(1);
        },
      );

      blocTest<LoginOptionsCubit, LoginOptionsState>(
        'emits [LoginWithGoogleLoading, LoginWithGoogleError] when user cancels',
        build: () {
          when(
            mockLoginWithGoogleUseCase.call(const NoParams()),
          ).thenAnswer((_) async => Left(Failure('User cancelled')));
          return cubit;
        },
        act: (cubit) => cubit.loginWithGoogle(),
        expect: () => [
          const LoginWithGoogleLoading(),
          const LoginWithGoogleError('User cancelled'),
        ],
      );

      blocTest<LoginOptionsCubit, LoginOptionsState>(
        'emits [LoginWithGoogleLoading, LoginWithGoogleError] when network error occurs',
        build: () {
          when(
            mockLoginWithGoogleUseCase.call(const NoParams()),
          ).thenAnswer((_) async => Left(Failure('Network error')));
          return cubit;
        },
        act: (cubit) => cubit.loginWithGoogle(),
        expect: () => [
          const LoginWithGoogleLoading(),
          const LoginWithGoogleError('Network error'),
        ],
      );

      blocTest<LoginOptionsCubit, LoginOptionsState>(
        'emits [LoginWithGoogleLoading, LoginWithGoogleError] when account not found',
        build: () {
          when(
            mockLoginWithGoogleUseCase.call(const NoParams()),
          ).thenAnswer((_) async => Left(Failure('Account not found')));
          return cubit;
        },
        act: (cubit) => cubit.loginWithGoogle(),
        expect: () => [
          const LoginWithGoogleLoading(),
          const LoginWithGoogleError('Account not found'),
        ],
      );

      blocTest<LoginOptionsCubit, LoginOptionsState>(
        'handles multiple login attempts',
        build: () {
          when(
            mockLoginWithGoogleUseCase.call(const NoParams()),
          ).thenAnswer((_) async => Left(Failure('User cancelled')));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loginWithGoogle();
          await cubit.loginWithGoogle();
        },
        expect: () => [
          const LoginWithGoogleLoading(),
          const LoginWithGoogleError('User cancelled'),
          const LoginWithGoogleLoading(),
          const LoginWithGoogleError('User cancelled'),
        ],
      );

      blocTest<LoginOptionsCubit, LoginOptionsState>(
        'handles successful retry after failed attempt',
        build: () {
          when(
            mockLoginWithGoogleUseCase.call(const NoParams()),
          ).thenAnswer((_) async => Left(Failure('User cancelled')));
          return cubit;
        },
        act: (cubit) async {
          // First attempt fails
          await cubit.loginWithGoogle();

          // Mock successful response for second attempt
          when(
            mockLoginWithGoogleUseCase.call(const NoParams()),
          ).thenAnswer((_) async => const Right(testUser));

          // Second attempt succeeds
          await cubit.loginWithGoogle();
        },
        expect: () => [
          const LoginWithGoogleLoading(),
          const LoginWithGoogleError('User cancelled'),
          const LoginWithGoogleLoading(),
          const LoginWithGoogleSuccess(user: testUser),
        ],
      );
    });

    group('loginWithFacebook', () {
      blocTest<LoginOptionsCubit, LoginOptionsState>(
        'emits [LoginWithFacebookLoading, LoginWithFacebookSuccess]',
        build: () => cubit,
        act: (cubit) => cubit.loginWithFacebook(),
        expect: () => [
          const LoginWithFacebookLoading(),
          const LoginWithFacebookSuccess(),
        ],
      );

      blocTest<LoginOptionsCubit, LoginOptionsState>(
        'does not call any use cases',
        build: () => cubit,
        act: (cubit) => cubit.loginWithFacebook(),
        verify: (_) {
          verifyNever(mockLoginWithGoogleUseCase.call(any));
        },
      );

      blocTest<LoginOptionsCubit, LoginOptionsState>(
        'handles multiple Facebook login attempts',
        build: () => cubit,
        act: (cubit) async {
          await cubit.loginWithFacebook();
          await cubit.loginWithFacebook();
        },
        expect: () => [
          const LoginWithFacebookLoading(),
          const LoginWithFacebookSuccess(),
          const LoginWithFacebookLoading(),
          const LoginWithFacebookSuccess(),
        ],
      );
    });

    group('State Properties', () {
      test('LoginWithGoogleSuccess should contain user', () {
        const state = LoginWithGoogleSuccess(user: testUser);
        expect(state.user.id, testUser.id);
        expect(state.user.email, testUser.email);
        expect(state.user.name, testUser.name);
        expect(state.user.avatar, testUser.avatar);
      });

      test('LoginWithGoogleError should contain error message', () {
        const state = LoginWithGoogleError('Test error');
        expect(state.message, 'Test error');
      });

      test('LoginWithFacebookError should contain error message', () {
        const state = LoginWithFacebookError('Test error');
        expect(state.message, 'Test error');
      });

      test('LoginOptionsInitial should be equatable', () {
        const state1 = LoginOptionsInitial();
        const state2 = LoginOptionsInitial();
        expect(state1, state2);
      });

      test('LoginWithGoogleLoading should be equatable', () {
        const state1 = LoginWithGoogleLoading();
        const state2 = LoginWithGoogleLoading();
        expect(state1, state2);
      });

      test('LoginWithFacebookLoading should be equatable', () {
        const state1 = LoginWithFacebookLoading();
        const state2 = LoginWithFacebookLoading();
        expect(state1, state2);
      });

      test('LoginWithFacebookSuccess should be equatable', () {
        const state1 = LoginWithFacebookSuccess();
        const state2 = LoginWithFacebookSuccess();
        expect(state1, state2);
      });
    });

    group('Mixed Login Methods', () {
      blocTest<LoginOptionsCubit, LoginOptionsState>(
        'handles switching between Google and Facebook login',
        build: () {
          when(
            mockLoginWithGoogleUseCase.call(const NoParams()),
          ).thenAnswer((_) async => const Right(testUser));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loginWithGoogle();
          await cubit.loginWithFacebook();
        },
        expect: () => [
          const LoginWithGoogleLoading(),
          const LoginWithGoogleSuccess(user: testUser),
          const LoginWithFacebookLoading(),
          const LoginWithFacebookSuccess(),
        ],
      );

      blocTest<LoginOptionsCubit, LoginOptionsState>(
        'handles Facebook login after failed Google login',
        build: () {
          when(
            mockLoginWithGoogleUseCase.call(const NoParams()),
          ).thenAnswer((_) async => Left(Failure('User cancelled')));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loginWithGoogle();
          await cubit.loginWithFacebook();
        },
        expect: () => [
          const LoginWithGoogleLoading(),
          const LoginWithGoogleError('User cancelled'),
          const LoginWithFacebookLoading(),
          const LoginWithFacebookSuccess(),
        ],
      );
    });
  });
}
