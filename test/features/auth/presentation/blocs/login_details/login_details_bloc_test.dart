import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/login_with_email.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<LoginWithEmailUseCase>()])
import 'login_details_bloc_test.mocks.dart';

void main() {
  late MockLoginWithEmailUseCase mockLoginWithEmailUseCase;
  late LoginDetailsBloc bloc;

  setUpAll(() {
    // Provide dummy values for Either types
    provideDummy<Either<Failure, User>>(
      const Right(User(id: '', name: '', email: '', avatar: '')),
    );
  });

  setUp(() {
    mockLoginWithEmailUseCase = MockLoginWithEmailUseCase();
    bloc = LoginDetailsBloc(loginWithEmailUseCase: mockLoginWithEmailUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('LoginDetailsBloc', () {
    const testEmail = 'test@test.com';
    const testPassword = 'password123';
    const testRememberMe = true;

    const testUser = User(
      id: '1',
      name: 'Test User',
      email: testEmail,
      avatar: 'https://example.com/avatar.png',
    );

    test('initial state should be LoginDetailsInitial', () {
      expect(bloc.state, const LoginDetailsInitial());
    });

    group('LoginSubmitted', () {
      blocTest<LoginDetailsBloc, LoginDetailsState>(
        'emits [LoginSubmitting, LoginSuccess] when login succeeds',
        build: () {
          when(
            mockLoginWithEmailUseCase.call(any),
          ).thenAnswer((_) async => const Right(testUser));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginSubmitted(
            email: testEmail,
            password: testPassword,
            rememberMe: testRememberMe,
          ),
        ),
        expect: () => [
          const LoginSubmitting(),
          const LoginSuccess(user: testUser),
        ],
        verify: (_) {
          verify(
            mockLoginWithEmailUseCase.call(
              const LoginWithEmailParams(
                email: testEmail,
                password: testPassword,
                rememberMe: testRememberMe,
              ),
            ),
          ).called(1);
        },
      );

      blocTest<LoginDetailsBloc, LoginDetailsState>(
        'emits [LoginSubmitting, LoginSuccess] with rememberMe false',
        build: () {
          when(
            mockLoginWithEmailUseCase.call(any),
          ).thenAnswer((_) async => const Right(testUser));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginSubmitted(email: testEmail, password: testPassword),
        ),
        expect: () => [
          const LoginSubmitting(),
          const LoginSuccess(user: testUser),
        ],
        verify: (_) {
          verify(
            mockLoginWithEmailUseCase.call(
              const LoginWithEmailParams(
                email: testEmail,
                password: testPassword,
              ),
            ),
          ).called(1);
        },
      );

      blocTest<LoginDetailsBloc, LoginDetailsState>(
        'emits [LoginSubmitting, LoginSuccess] with default rememberMe (false)',
        build: () {
          when(
            mockLoginWithEmailUseCase.call(any),
          ).thenAnswer((_) async => const Right(testUser));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginSubmitted(email: testEmail, password: testPassword),
        ),
        expect: () => [
          const LoginSubmitting(),
          const LoginSuccess(user: testUser),
        ],
        verify: (_) {
          final captured =
              verify(mockLoginWithEmailUseCase.call(captureAny)).captured.single
                  as LoginWithEmailParams;
          expect(captured.email, testEmail);
          expect(captured.password, testPassword);
          expect(captured.rememberMe, false);
        },
      );

      blocTest<LoginDetailsBloc, LoginDetailsState>(
        'emits [LoginSubmitting, LoginFailure] when login fails with invalid credentials',
        build: () {
          when(
            mockLoginWithEmailUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Invalid credentials')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginSubmitted(email: testEmail, password: testPassword),
        ),
        expect: () => [
          const LoginSubmitting(),
          const LoginFailure('Invalid credentials'),
        ],
      );

      blocTest<LoginDetailsBloc, LoginDetailsState>(
        'emits [LoginSubmitting, LoginFailure] when network error occurs',
        build: () {
          when(
            mockLoginWithEmailUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Network error')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginSubmitted(email: testEmail, password: testPassword),
        ),
        expect: () => [
          const LoginSubmitting(),
          const LoginFailure('Network error'),
        ],
      );

      blocTest<LoginDetailsBloc, LoginDetailsState>(
        'emits [LoginSubmitting, LoginFailure] when server error occurs',
        build: () {
          when(
            mockLoginWithEmailUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Server error')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginSubmitted(email: testEmail, password: testPassword),
        ),
        expect: () => [
          const LoginSubmitting(),
          const LoginFailure('Server error'),
        ],
      );

      blocTest<LoginDetailsBloc, LoginDetailsState>(
        'emits [LoginSubmitting, LoginFailure] when user account is locked',
        build: () {
          when(
            mockLoginWithEmailUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Account locked')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginSubmitted(email: testEmail, password: testPassword),
        ),
        expect: () => [
          const LoginSubmitting(),
          const LoginFailure('Account locked'),
        ],
      );

      blocTest<LoginDetailsBloc, LoginDetailsState>(
        'handles multiple login attempts with different credentials',
        build: () {
          when(
            mockLoginWithEmailUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Invalid credentials')));
          return bloc;
        },
        act: (bloc) async {
          bloc.add(
            const LoginSubmitted(email: testEmail, password: 'wrongPassword'),
          );
          await Future<void>.delayed(const Duration(milliseconds: 100));
          bloc.add(
            const LoginSubmitted(email: testEmail, password: testPassword),
          );
        },
        expect: () => [
          const LoginSubmitting(),
          const LoginFailure('Invalid credentials'),
          const LoginSubmitting(),
          const LoginFailure('Invalid credentials'),
        ],
      );

      blocTest<LoginDetailsBloc, LoginDetailsState>(
        'handles successful retry after failed login',
        build: () {
          when(
            mockLoginWithEmailUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Invalid credentials')));
          return bloc;
        },
        act: (bloc) async {
          // First attempt fails
          bloc.add(
            const LoginSubmitted(email: testEmail, password: 'wrongPassword'),
          );
          await Future<void>.delayed(const Duration(milliseconds: 100));

          // Mock successful response for second attempt
          when(
            mockLoginWithEmailUseCase.call(any),
          ).thenAnswer((_) async => const Right(testUser));

          // Second attempt succeeds
          bloc.add(
            const LoginSubmitted(email: testEmail, password: testPassword),
          );
        },
        expect: () => [
          const LoginSubmitting(),
          const LoginFailure('Invalid credentials'),
          const LoginSubmitting(),
          const LoginSuccess(user: testUser),
        ],
      );
    });

    group('LoginSubmitted - Edge Cases', () {
      blocTest<LoginDetailsBloc, LoginDetailsState>(
        'handles login with empty email',
        build: () {
          when(
            mockLoginWithEmailUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Email is required')));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const LoginSubmitted(email: '', password: testPassword)),
        expect: () => [
          const LoginSubmitting(),
          const LoginFailure('Email is required'),
        ],
      );

      blocTest<LoginDetailsBloc, LoginDetailsState>(
        'handles login with empty password',
        build: () {
          when(
            mockLoginWithEmailUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Password is required')));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const LoginSubmitted(email: testEmail, password: '')),
        expect: () => [
          const LoginSubmitting(),
          const LoginFailure('Password is required'),
        ],
      );

      blocTest<LoginDetailsBloc, LoginDetailsState>(
        'handles login with invalid email format',
        build: () {
          when(
            mockLoginWithEmailUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Invalid email format')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginSubmitted(email: 'invalid-email', password: testPassword),
        ),
        expect: () => [
          const LoginSubmitting(),
          const LoginFailure('Invalid email format'),
        ],
      );
    });

    group('State Properties', () {
      test('LoginSuccess should contain correct user data', () {
        const state = LoginSuccess(user: testUser);
        expect(state.user.id, testUser.id);
        expect(state.user.email, testUser.email);
        expect(state.user.name, testUser.name);
        expect(state.user.avatar, testUser.avatar);
      });

      test('LoginFailure should contain error message', () {
        const state = LoginFailure('Test error');
        expect(state.message, 'Test error');
      });

      test('LoginDetailsInitial should be equatable', () {
        const state1 = LoginDetailsInitial();
        const state2 = LoginDetailsInitial();
        expect(state1, state2);
      });

      test('LoginSubmitting should be equatable', () {
        const state1 = LoginSubmitting();
        const state2 = LoginSubmitting();
        expect(state1, state2);
      });
    });
  });
}
