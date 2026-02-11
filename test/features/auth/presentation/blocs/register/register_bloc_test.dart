import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/register.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<RegisterUseCase>()])
import 'register_bloc_test.mocks.dart';

void main() {
  late MockRegisterUseCase mockRegisterUseCase;
  late RegisterBloc bloc;

  setUpAll(() {
    // Provide dummy values for Either types
    provideDummy<Either<Failure, User>>(
      const Right(User(id: '', firstName: '', lastName: '', email: '', avatar: '')),
    );
  });

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    bloc = RegisterBloc(registerUseCase: mockRegisterUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('RegisterBloc', () {
    const testFirstName = 'John';
    const testLastName = 'Doe';
    const testUsername = 'johndoe';
    const testEmail = 'john.doe@test.com';
    const testPassword = 'password123';
    const testRepeatPassword = 'password123';

    const testUser = User(
      id: '1',
      firstName: testFirstName,
      lastName: testLastName,
      email: testEmail,
      avatar: 'https://example.com/avatar.png',
    );

    test('initial state should be RegisterInitial', () {
      expect(bloc.state, const RegisterInitial());
    });

    group('RegisterSubmitted', () {
      blocTest<RegisterBloc, RegisterState>(
        'emits [RegisterSubmitting, RegisterSuccess] when registration succeeds',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => const Right(testUser));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: testFirstName,
            lastName: testLastName,
            username: testUsername,
            email: testEmail,
            password: testPassword,
            repeatPassword: testRepeatPassword,
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterSuccess(user: testUser),
        ],
        verify: (_) {
          verify(
            mockRegisterUseCase.call(
              const RegisterParams(
                firstName: testFirstName,
                lastName: testLastName,
                username: testUsername,
                email: testEmail,
                password: testPassword,
                repeatPassword: testRepeatPassword,
              ),
            ),
          ).called(1);
        },
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [RegisterSubmitting, RegisterFailure] when registration fails with existing email',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Email already exists')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: testFirstName,
            lastName: testLastName,
            username: testUsername,
            email: testEmail,
            password: testPassword,
            repeatPassword: testRepeatPassword,
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Email already exists'),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [RegisterSubmitting, RegisterFailure] when registration fails with existing username',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Username already exists')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: testFirstName,
            lastName: testLastName,
            username: testUsername,
            email: testEmail,
            password: testPassword,
            repeatPassword: testRepeatPassword,
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Username already exists'),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [RegisterSubmitting, RegisterFailure] when passwords do not match',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Passwords do not match')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: testFirstName,
            lastName: testLastName,
            username: testUsername,
            email: testEmail,
            password: testPassword,
            repeatPassword: 'differentPassword',
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Passwords do not match'),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [RegisterSubmitting, RegisterFailure] when network error occurs',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Network error')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: testFirstName,
            lastName: testLastName,
            username: testUsername,
            email: testEmail,
            password: testPassword,
            repeatPassword: testRepeatPassword,
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Network error'),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [RegisterSubmitting, RegisterFailure] when server error occurs',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Server error')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: testFirstName,
            lastName: testLastName,
            username: testUsername,
            email: testEmail,
            password: testPassword,
            repeatPassword: testRepeatPassword,
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Server error'),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'handles multiple registration attempts',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Email already exists')));
          return bloc;
        },
        act: (bloc) async {
          bloc.add(
            const RegisterSubmitted(
              firstName: testFirstName,
              lastName: testLastName,
              username: testUsername,
              email: testEmail,
              password: testPassword,
              repeatPassword: testRepeatPassword,
            ),
          );
          await Future<void>.delayed(const Duration(milliseconds: 100));
          bloc.add(
            const RegisterSubmitted(
              firstName: testFirstName,
              lastName: testLastName,
              username: 'differentusername',
              email: 'different@test.com',
              password: testPassword,
              repeatPassword: testRepeatPassword,
            ),
          );
        },
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Email already exists'),
          const RegisterSubmitting(),
          const RegisterFailure('Email already exists'),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'handles successful retry after failed registration',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Email already exists')));
          return bloc;
        },
        act: (bloc) async {
          // First attempt fails
          bloc.add(
            const RegisterSubmitted(
              firstName: testFirstName,
              lastName: testLastName,
              username: testUsername,
              email: testEmail,
              password: testPassword,
              repeatPassword: testRepeatPassword,
            ),
          );
          await Future<void>.delayed(const Duration(milliseconds: 100));

          // Mock successful response for second attempt
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => const Right(testUser));

          // Second attempt succeeds
          bloc.add(
            const RegisterSubmitted(
              firstName: testFirstName,
              lastName: testLastName,
              username: 'newusername',
              email: 'new@test.com',
              password: testPassword,
              repeatPassword: testRepeatPassword,
            ),
          );
        },
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Email already exists'),
          const RegisterSubmitting(),
          const RegisterSuccess(user: testUser),
        ],
      );
    });

    group('RegisterSubmitted - Validation Cases', () {
      blocTest<RegisterBloc, RegisterState>(
        'emits failure when firstName is empty',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('First name is required')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: '',
            lastName: testLastName,
            username: testUsername,
            email: testEmail,
            password: testPassword,
            repeatPassword: testRepeatPassword,
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('First name is required'),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits failure when lastName is empty',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Last name is required')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: testFirstName,
            lastName: '',
            username: testUsername,
            email: testEmail,
            password: testPassword,
            repeatPassword: testRepeatPassword,
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Last name is required'),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits failure when username is empty',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Username is required')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: testFirstName,
            lastName: testLastName,
            username: '',
            email: testEmail,
            password: testPassword,
            repeatPassword: testRepeatPassword,
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Username is required'),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits failure when email is empty',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Email is required')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: testFirstName,
            lastName: testLastName,
            username: testUsername,
            email: '',
            password: testPassword,
            repeatPassword: testRepeatPassword,
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Email is required'),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits failure when email format is invalid',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Invalid email format')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: testFirstName,
            lastName: testLastName,
            username: testUsername,
            email: 'invalid-email',
            password: testPassword,
            repeatPassword: testRepeatPassword,
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Invalid email format'),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits failure when password is empty',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Password is required')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: testFirstName,
            lastName: testLastName,
            username: testUsername,
            email: testEmail,
            password: '',
            repeatPassword: testRepeatPassword,
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Password is required'),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits failure when password is too weak',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Password too weak')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: testFirstName,
            lastName: testLastName,
            username: testUsername,
            email: testEmail,
            password: '123',
            repeatPassword: '123',
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Password too weak'),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits failure when username is too short',
        build: () {
          when(
            mockRegisterUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure('Username too short')));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterSubmitted(
            firstName: testFirstName,
            lastName: testLastName,
            username: 'ab',
            email: testEmail,
            password: testPassword,
            repeatPassword: testRepeatPassword,
          ),
        ),
        expect: () => [
          const RegisterSubmitting(),
          const RegisterFailure('Username too short'),
        ],
      );
    });

    group('State Properties', () {
      test('RegisterSuccess should contain correct user data', () {
        const state = RegisterSuccess(user: testUser);
        expect(state.user.id, testUser.id);
        expect(state.user.firstName, testUser.firstName);
        expect(state.user.lastName, testUser.lastName);
        expect(state.user.email, testUser.email);
        expect(state.user.avatar, testUser.avatar);
      });

      test('RegisterFailure should contain error message', () {
        const state = RegisterFailure('Test error');
        expect(state.message, 'Test error');
      });

      test('RegisterInitial should be equatable', () {
        const state1 = RegisterInitial();
        const state2 = RegisterInitial();
        expect(state1, state2);
      });

      test('RegisterSubmitting should be equatable', () {
        const state1 = RegisterSubmitting();
        const state2 = RegisterSubmitting();
        expect(state1, state2);
      });
    });

    group('Event Properties', () {
      test('RegisterSubmitted should have correct props', () {
        const event = RegisterSubmitted(
          firstName: testFirstName,
          lastName: testLastName,
          username: testUsername,
          email: testEmail,
          password: testPassword,
          repeatPassword: testRepeatPassword,
        );

        expect(event.firstName, testFirstName);
        expect(event.lastName, testLastName);
        expect(event.username, testUsername);
        expect(event.email, testEmail);
        expect(event.password, testPassword);
        expect(event.repeatPassword, testRepeatPassword);
      });

      test('RegisterSubmitted should be equatable', () {
        const event1 = RegisterSubmitted(
          firstName: testFirstName,
          lastName: testLastName,
          username: testUsername,
          email: testEmail,
          password: testPassword,
          repeatPassword: testRepeatPassword,
        );

        const event2 = RegisterSubmitted(
          firstName: testFirstName,
          lastName: testLastName,
          username: testUsername,
          email: testEmail,
          password: testPassword,
          repeatPassword: testRepeatPassword,
        );

        expect(event1, event2);
      });
    });
  });
}
