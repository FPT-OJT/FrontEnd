import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/current_user.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/logout.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<CurrentUserUseCase>(), MockSpec<LogoutUseCase>()])
import 'auth_bloc_test.mocks.dart';

void main() {
  late MockCurrentUserUseCase mockCurrentUserUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late AuthBloc authBloc;

  setUpAll(() {
    // Provide dummy values for Either types
    provideDummy<Either<Failure, User>>(
      const Right(
        User(id: '', firstName: '', lastName: '', email: '', avatar: ''),
      ),
    );
    provideDummy<Either<Failure, void>>(const Right(null));
  });

  setUp(() {
    mockCurrentUserUseCase = MockCurrentUserUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    authBloc = AuthBloc(
      currentUserUseCase: mockCurrentUserUseCase,
      logoutUseCase: mockLogoutUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    const testUser = User(
      id: '1',
      firstName: 'Test',
      lastName: 'User',
      email: 'test@test.com',
      avatar: 'https://example.com/avatar.png',
    );

    test('initial state should be AuthInitial', () {
      expect(authBloc.state, const AuthInitial());
    });

    group('AuthIsUserLoggedInEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoggedIn] when getCurrentUser succeeds',
        build: () {
          when(
            mockCurrentUserUseCase.call(const NoParams()),
          ).thenAnswer((_) async => const Right(testUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthIsUserLoggedInEvent()),
        expect: () => [const AuthLoading(), const AuthLoggedIn(user: testUser)],
        verify: (_) {
          verify(mockCurrentUserUseCase.call(const NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when getCurrentUser fails',
        build: () {
          when(
            mockCurrentUserUseCase.call(const NoParams()),
          ).thenAnswer((_) async => Left(Failure('Network error')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthIsUserLoggedInEvent()),
        expect: () => [const AuthLoading(), const AuthFailure('Network error')],
        verify: (_) {
          verify(mockCurrentUserUseCase.call(const NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when user not logged in',
        build: () {
          when(
            mockCurrentUserUseCase.call(const NoParams()),
          ).thenAnswer((_) async => Left(Failure('User not logged in!')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthIsUserLoggedInEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthFailure('User not logged in!'),
        ],
      );
    });

    group('AuthLoggedInEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoggedIn] with provided user',
        build: () => authBloc,
        act: (bloc) => bloc.add(const AuthLoggedInEvent(user: testUser)),
        expect: () => [const AuthLoggedIn(user: testUser)],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoggedIn] with different user',
        build: () => authBloc,
        act: (bloc) {
          const differentUser = User(
            id: '2',
            firstName: 'Different',
            lastName: 'User',
            email: 'different@test.com',
            avatar: 'https://example.com/different.png',
          );
          return bloc.add(const AuthLoggedInEvent(user: differentUser));
        },
        expect: () => [
          isA<AuthLoggedIn>().having((state) => state.user.id, 'user id', '2'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'does not call any use cases',
        build: () => authBloc,
        act: (bloc) => bloc.add(const AuthLoggedInEvent(user: testUser)),
        verify: (_) {
          verifyNever(mockCurrentUserUseCase.call(any));
          verifyNever(mockLogoutUseCase.call(any));
        },
      );
    });

    group('AuthLoggedOutEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoggedOut] when logout succeeds',
        build: () {
          when(
            mockLogoutUseCase.call(const NoParams()),
          ).thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthLoggedOutEvent()),
        expect: () => [const AuthLoading(), const AuthLoggedOut()],
        verify: (_) {
          verify(mockLogoutUseCase.call(const NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when logout fails',
        build: () {
          when(
            mockLogoutUseCase.call(const NoParams()),
          ).thenAnswer((_) async => Left(Failure('Logout failed')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthLoggedOutEvent()),
        expect: () => [const AuthLoading(), const AuthFailure('Logout failed')],
        verify: (_) {
          verify(mockLogoutUseCase.call(const NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when server error occurs',
        build: () {
          when(
            mockLogoutUseCase.call(const NoParams()),
          ).thenAnswer((_) async => Left(Failure('Server error')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthLoggedOutEvent()),
        expect: () => [const AuthLoading(), const AuthFailure('Server error')],
      );
    });

    group('Multiple Events', () {
      blocTest<AuthBloc, AuthState>(
        'handles multiple events in sequence',
        build: () {
          when(
            mockCurrentUserUseCase.call(const NoParams()),
          ).thenAnswer((_) async => const Right(testUser));
          when(
            mockLogoutUseCase.call(const NoParams()),
          ).thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) async {
          bloc.add(const AuthIsUserLoggedInEvent());
          await Future<void>.delayed(const Duration(milliseconds: 100));
          bloc.add(const AuthLoggedOutEvent());
        },
        expect: () => [
          const AuthLoading(),
          const AuthLoggedIn(user: testUser),
          const AuthLoading(),
          const AuthLoggedOut(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'handles AuthLoggedInEvent after logout',
        build: () {
          when(
            mockLogoutUseCase.call(const NoParams()),
          ).thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) async {
          bloc.add(const AuthLoggedOutEvent());
          await Future<void>.delayed(const Duration(milliseconds: 100));
          bloc.add(const AuthLoggedInEvent(user: testUser));
        },
        expect: () => [
          const AuthLoading(),
          const AuthLoggedOut(),
          const AuthLoggedIn(user: testUser),
        ],
      );
    });
  });
}
