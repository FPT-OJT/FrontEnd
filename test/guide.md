# Testing Guide

This guide provides comprehensive instructions for writing tests in this Flutter project using Clean Architecture principles.

## Table of Contents

1. [Setup & Dependencies](#setup--dependencies)
2. [Testing BLoCs/Cubits](#testing-blocscubits)
3. [Testing Repositories](#testing-repositories)
4. [Testing UseCases](#testing-usecases)
5. [Widget Testing](#widget-testing)
6. [Best Practices](#best-practices)

---

## Setup & Dependencies

### Required Dependencies

Ensure your `pubspec.yaml` includes:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^10.0.0      # For BLoC testing
  mockito: ^5.6.3         # For mocking
  build_runner: ^2.10.5   # For generating mocks
```

### Generating Mocks

Use `@GenerateNiceMocks` annotation and run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/presentation/blocs/auth_bloc_test.dart

# Run with coverage
flutter test --coverage

# View coverage (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Testing BLoCs/Cubits

BLoCs and Cubits manage state and business logic. Use `bloc_test` package for streamlined testing.

### Basic Structure

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks for dependencies
@GenerateNiceMocks([
  MockSpec<YourUseCase>(),
  MockSpec<AnotherDependency>(),
])
import 'your_bloc_test.mocks.dart';

void main() {
  late MockYourUseCase mockUseCase;
  late YourBloc bloc;

  setUp(() {
    mockUseCase = MockYourUseCase();
    bloc = YourBloc(yourUseCase: mockUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('YourBloc', () {
    // Tests go here
  });
}
```

### Example: Testing AuthBloc

**File:** `test/features/auth/presentation/blocs/auth/auth_bloc_test.dart`

```dart
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

@GenerateNiceMocks([
  MockSpec<CurrentUserUseCase>(),
  MockSpec<LogoutUseCase>(),
])
import 'auth_bloc_test.mocks.dart';

void main() {
  late MockCurrentUserUseCase mockCurrentUserUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late AuthBloc authBloc;

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
    final testUser = User(
      id: '1',
      name: 'Test User',
      email: 'test@test.com',
      avatar: 'https://example.com/avatar.png',
    );

    group('AuthIsUserLoggedInEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoggedIn] when getCurrentUser succeeds',
        build: () {
          when(mockCurrentUserUseCase.call(NoParams()))
              .thenAnswer((_) async => Right(testUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthIsUserLoggedInEvent()),
        expect: () => [
          const AuthLoading(),
          AuthLoggedIn(user: testUser),
        ],
        verify: (_) {
          verify(mockCurrentUserUseCase.call(NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when getCurrentUser fails',
        build: () {
          when(mockCurrentUserUseCase.call(NoParams()))
              .thenAnswer((_) async => Left(Failure('Network error')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthIsUserLoggedInEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthFailure('Network error'),
        ],
      );
    });

    group('AuthLoggedInEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoggedIn] with provided user',
        build: () => authBloc,
        act: (bloc) => bloc.add(AuthLoggedInEvent(user: testUser)),
        expect: () => [AuthLoggedIn(user: testUser)],
      );
    });

    group('AuthLoggedOutEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoggedOut] when logout succeeds',
        build: () {
          when(mockLogoutUseCase.call(NoParams()))
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthLoggedOutEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthLoggedOut(),
        ],
        verify: (_) {
          verify(mockLogoutUseCase.call(NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when logout fails',
        build: () {
          when(mockLogoutUseCase.call(NoParams()))
              .thenAnswer((_) async => Left(Failure('Logout failed')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthLoggedOutEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthFailure('Logout failed'),
        ],
      );
    });
  });
}
```

### Example: Testing Cubit with State Management

**File:** `test/features/intro/presentation/blocs/onboarding/onboarding_cubit_test.dart`

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
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
  late OnboardingCubit cubit;

  setUp(() {
    mockEndOnboardingUseCase = MockEndOnboardingUseCase();
    mockGetIsOnboardingUseCase = MockGetOnboardingCompletionStatusUseCase();
    cubit = OnboardingCubit(
      endOnboardingUseCase: mockEndOnboardingUseCase,
      getIsOnboardingUseCase: mockGetIsOnboardingUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('OnboardingCubit', () {
    group('initialize', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'emits [OnboardingLoading, OnboardingCompleted] when already completed',
        build: () {
          when(mockGetIsOnboardingUseCase.call(NoParams()))
              .thenAnswer((_) async => const Right(true));
          return cubit;
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const OnboardingLoading(),
          const OnboardingCompleted(),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits [OnboardingLoading, OnboardingSession] when not completed',
        build: () {
          when(mockGetIsOnboardingUseCase.call(NoParams()))
              .thenAnswer((_) async => const Right(false));
          return cubit;
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const OnboardingLoading(),
          OnboardingSession(0, onboardingItems),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits [OnboardingLoading, OnboardingError] when initialization fails',
        build: () {
          when(mockGetIsOnboardingUseCase.call(NoParams()))
              .thenAnswer((_) async => Left(Failure('Storage error')));
          return cubit;
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const OnboardingLoading(),
          const OnboardingError('Storage error'),
        ],
      );
    });

    group('pageChanged', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'updates page when pageChanged is called',
        build: () => cubit,
        seed: () => OnboardingSession(0, onboardingItems),
        act: (cubit) => cubit.pageChanged(1.5),
        expect: () => [
          OnboardingSession(1.5, onboardingItems),
        ],
      );
    });

    group('complete', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'emits [OnboardingCompleted] when complete succeeds',
        build: () {
          when(mockEndOnboardingUseCase.call(NoParams()))
              .thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.complete(),
        expect: () => [const OnboardingCompleted()],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits [OnboardingError] when complete fails',
        build: () {
          when(mockEndOnboardingUseCase.call(NoParams()))
              .thenAnswer((_) async => Left(Failure('Save failed')));
          return cubit;
        },
        act: (cubit) => cubit.complete(),
        expect: () => [const OnboardingError('Save failed')],
      );
    });
  });

  group('OnboardingSession state properties', () {
    test('isLast returns true when on last page', () {
      final state = OnboardingSession(
        (onboardingItems.length - 1).toDouble(),
        onboardingItems,
      );
      expect(state.isLast, true);
    });

    test('isLast returns false when not on last page', () {
      final state = OnboardingSession(0.0, onboardingItems);
      expect(state.isLast, false);
    });

    test('isFirst returns true when on first page', () {
      final state = OnboardingSession(0.0, onboardingItems);
      expect(state.isFirst, true);
    });

    test('isFirst returns false when not on first page', () {
      final state = OnboardingSession(1.0, onboardingItems);
      expect(state.isFirst, false);
    });

    test('currentIndex returns correct rounded index', () {
      final state = OnboardingSession(1.6, onboardingItems);
      expect(state.currentIndex, 2);
    });

    test('currentItem returns correct item', () {
      final state = OnboardingSession(1.0, onboardingItems);
      expect(state.currentItem, onboardingItems[1]);
    });
  });
}
```

### Testing Multi-Step Flows

**Example:** ForgotPasswordBloc with multi-step workflow

```dart
blocTest<ForgotPasswordBloc, ForgotPasswordState>(
  'complete flow: send code → verify OTP → reset password',
  build: () {
    when(mockForgotPasswordUseCase.call(any))
        .thenAnswer((_) async => const Right(null));
    when(mockResetPasswordUseCase.call(any))
        .thenAnswer((_) async => const Right(null));
    return bloc;
  },
  act: (bloc) async {
    // Step 1: Send reset code
    bloc.add(SendResetCodeRequested(email: 'test@test.com'));
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Step 2: Verify OTP
    bloc.add(VerifyOtpRequested(otp: '123456'));
    await Future.delayed(const Duration(milliseconds: 1100)); // Account for delay
    
    // Step 3: Reset password
    bloc.add(ResetPasswordRequested(newPassword: 'newPass123'));
  },
  expect: () => [
    SendingResetCode(),
    ResetCodeSent(email: 'test@test.com'),
    VerifyingOtp(email: 'test@test.com'),
    OtpVerified(email: 'test@test.com', otp: '123456'),
    ResettingPassword(),
    PasswordResetSuccess(),
  ],
);
```

---

## Testing Repositories

Repositories coordinate data sources and convert DTOs to entities. Mock all dependencies.

### Basic Structure

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<YourDataSource>(),
  MockSpec<AnotherDependency>(),
])
import 'your_repository_test.mocks.dart';

void main() {
  late MockYourDataSource mockDataSource;
  late YourRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockYourDataSource();
    repository = YourRepositoryImpl(dataSource: mockDataSource);
  });

  group('YourRepository', () {
    // Tests go here
  });
}
```

### Example: Testing AuthRepositoryImpl

**File:** `test/features/auth/data/repositories/auth_repository_impl_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/common/token/token_store.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/auth/data/datasources/auth_datasource.dart';
import 'package:fpt_ojt/features/auth/data/datasources/google_auth_data_source.dart';
import 'package:fpt_ojt/features/auth/data/models/auth_models.dart';
import 'package:fpt_ojt/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<AuthDataSource>(),
  MockSpec<GoogleAuthDataSource>(),
  MockSpec<TokenStore>(),
])
import 'auth_repository_impl_test.mocks.dart';

void main() {
  late MockAuthDataSource mockAuthDataSource;
  late MockGoogleAuthDataSource mockGoogleAuthDataSource;
  late MockTokenStore mockTokenStore;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    mockGoogleAuthDataSource = MockGoogleAuthDataSource();
    mockTokenStore = MockTokenStore();
    repository = AuthRepositoryImpl(
      authDataSource: mockAuthDataSource,
      googleAuthDataSource: mockGoogleAuthDataSource,
      tokenDataSource: mockTokenStore,
    );
  });

  group('loginWithEmail', () {
    const email = 'test@test.com';
    const password = 'password123';
    const rememberMe = true;

    final loginResponse = LoginResponse(
      status: 'success',
      data: LoginData(
        accessToken: 'access_token_123',
        refreshToken: 'refresh_token_456',
        userId: 'user_1',
        role: 'USER',
      ),
    );

    test('should save tokens and return User on success', () async {
      // Arrange
      when(mockAuthDataSource.loginWithEmail(
        email,
        password,
        rememberMe: rememberMe,
      )).thenAnswer((_) async => loginResponse);
      
      when(mockTokenStore.saveAccessToken(any))
          .thenAnswer((_) async => {});
      when(mockTokenStore.saveRefreshToken(any, rememberMe: anyNamed('rememberMe')))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.loginWithEmail(
        email,
        password,
        rememberMe: rememberMe,
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) {
          expect(user.id, 'user_1');
          expect(user.name, 'USER');
        },
      );

      verify(mockAuthDataSource.loginWithEmail(
        email,
        password,
        rememberMe: rememberMe,
      )).called(1);
      verify(mockTokenStore.saveAccessToken('access_token_123')).called(1);
      verify(mockTokenStore.saveRefreshToken(
        'refresh_token_456',
        rememberMe: rememberMe,
      )).called(1);
    });

    test('should return Failure when datasource throws exception', () async {
      // Arrange
      when(mockAuthDataSource.loginWithEmail(
        email,
        password,
        rememberMe: rememberMe,
      )).thenThrow(Exception('Network error'));

      // Act
      final result = await repository.loginWithEmail(
        email,
        password,
        rememberMe: rememberMe,
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Network error')),
        (user) => fail('Should return Left'),
      );

      verifyNever(mockTokenStore.saveAccessToken(any));
      verifyNever(mockTokenStore.saveRefreshToken(any, rememberMe: anyNamed('rememberMe')));
    });
  });

  group('getCurrentUser', () {
    test('should return User when token exists and user data is valid', () async {
      // Arrange
      const refreshToken = 'valid_refresh_token';
      final userModel = UserModel(
        id: '1',
        name: 'John Doe',
        email: 'john@test.com',
        avatar: 'avatar.png',
      );

      when(mockTokenStore.getRefreshToken())
          .thenAnswer((_) async => refreshToken);
      when(mockAuthDataSource.getCurrentUser())
          .thenAnswer((_) async => userModel);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) {
          expect(user.id, '1');
          expect(user.name, 'John Doe');
          expect(user.email, 'john@test.com');
        },
      );
    });

    test('should return Failure when refresh token is empty', () async {
      // Arrange
      when(mockTokenStore.getRefreshToken()).thenAnswer((_) async => '');

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'User not logged in!'),
        (user) => fail('Should return Left'),
      );

      verifyNever(mockAuthDataSource.getCurrentUser());
    });

    test('should return Failure when user data is null', () async {
      // Arrange
      when(mockTokenStore.getRefreshToken())
          .thenAnswer((_) async => 'token');
      when(mockAuthDataSource.getCurrentUser())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'User not logged in!'),
        (user) => fail('Should return Left'),
      );
    });
  });

  group('logout', () {
    test('should clear tokens after successful logout', () async {
      // Arrange
      when(mockAuthDataSource.logout()).thenAnswer((_) async => {});
      when(mockTokenStore.deleteAccessToken()).thenAnswer((_) async => {});
      when(mockTokenStore.deleteRefreshToken()).thenAnswer((_) async => {});

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.isRight(), true);
      verify(mockAuthDataSource.logout()).called(1);
      verify(mockTokenStore.deleteAccessToken()).called(1);
      verify(mockTokenStore.deleteRefreshToken()).called(1);
    });

    test('should return Failure when logout fails', () async {
      // Arrange
      when(mockAuthDataSource.logout()).thenThrow(Exception('Server error'));

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.isLeft(), true);
      verifyNever(mockTokenStore.deleteAccessToken());
    });
  });
}
```

---

## Testing UseCases

UseCases are simple and typically just delegate to repositories. Test parameter passing and result forwarding.

### Basic Structure

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<YourRepository>()])
import 'your_usecase_test.mocks.dart';

void main() {
  late MockYourRepository mockRepository;
  late YourUseCase useCase;

  setUp(() {
    mockRepository = MockYourRepository();
    useCase = YourUseCase(repository: mockRepository);
  });

  group('YourUseCase', () {
    // Tests go here
  });
}
```

### Example: Testing LoginWithEmailUseCase

**File:** `test/features/auth/domain/usecases/login_with_email_test.dart`

```dart
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
  });

  group('LoginWithEmailUseCase', () {
    const email = 'test@test.com';
    const password = 'password123';
    const rememberMe = true;

    final params = LoginWithEmailParams(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );

    final expectedUser = User(
      id: '1',
      name: 'Test User',
      email: email,
      avatar: 'avatar.png',
    );

    test('should call repository loginWithEmail with correct parameters', () async {
      // Arrange
      when(mockAuthRepository.loginWithEmail(
        any,
        any,
        rememberMe: anyNamed('rememberMe'),
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      await useCase.call(params);

      // Assert
      verify(mockAuthRepository.loginWithEmail(
        email,
        password,
        rememberMe: rememberMe,
      )).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return User when repository call succeeds', () async {
      // Arrange
      when(mockAuthRepository.loginWithEmail(
        any,
        any,
        rememberMe: anyNamed('rememberMe'),
      )).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result = await useCase.call(params);

      // Assert
      expect(result, Right(expectedUser));
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) {
          expect(user.id, expectedUser.id);
          expect(user.email, expectedUser.email);
        },
      );
    });

    test('should return Failure when repository call fails', () async {
      // Arrange
      final expectedFailure = Failure('Invalid credentials');
      when(mockAuthRepository.loginWithEmail(
        any,
        any,
        rememberMe: anyNamed('rememberMe'),
      )).thenAnswer((_) async => Left(expectedFailure));

      // Act
      final result = await useCase.call(params);

      // Assert
      expect(result, Left(expectedFailure));
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Invalid credentials'),
        (user) => fail('Should return Left'),
      );
    });
  });

  group('LoginWithEmailParams', () {
    test('should create params with correct values', () {
      // Act
      final params = LoginWithEmailParams(
        email: 'test@test.com',
        password: 'pass123',
        rememberMe: true,
      );

      // Assert
      expect(params.email, 'test@test.com');
      expect(params.password, 'pass123');
      expect(params.rememberMe, true);
    });

    test('should default rememberMe to false', () {
      // Act
      final params = LoginWithEmailParams(
        email: 'test@test.com',
        password: 'pass123',
      );

      // Assert
      expect(params.rememberMe, false);
    });
  });
}
```

### Example: Testing Logout UseCase (NoParams)

```dart
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
  });

  group('LogoutUseCase', () {
    test('should call repository logout', () async {
      // Arrange
      when(mockAuthRepository.logout())
          .thenAnswer((_) async => const Right(null));

      // Act
      await useCase.call(NoParams());

      // Assert
      verify(mockAuthRepository.logout()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Right when logout succeeds', () async {
      // Arrange
      when(mockAuthRepository.logout())
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase.call(NoParams());

      // Assert
      expect(result.isRight(), true);
    });

    test('should return Failure when logout fails', () async {
      // Arrange
      final expectedFailure = Failure('Logout failed');
      when(mockAuthRepository.logout())
          .thenAnswer((_) async => Left(expectedFailure));

      // Act
      final result = await useCase.call(NoParams());

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Logout failed'),
        (_) => fail('Should return Left'),
      );
    });
  });
}
```

---

## Widget Testing

Widget tests verify UI behavior, user interactions, and widget state.

### Basic Structure

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<YourBloc>()])
import 'your_widget_test.mocks.dart';

void main() {
  late MockYourBloc mockBloc;

  setUp(() {
    mockBloc = MockYourBloc();
  });

  testWidgets('description', (WidgetTester tester) async {
    // Build widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<YourBloc>(
          create: (_) => mockBloc,
          child: YourWidget(),
        ),
      ),
    );

    // Interact and assert
  });
}
```

### Example: Testing Custom TextField Widget

**File:** `test/features/auth/presentation/widgets/custom_text_field_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';

void main() {
  group('CustomTextField', () {
    testWidgets('should render with label and hint', (WidgetTester tester) async {
      // Arrange
      const label = 'Email';
      const hint = 'Enter your email';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: label,
              hint: hint,
              controller: TextEditingController(),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(label), findsOneWidget);
      expect(find.text(hint), findsOneWidget);
    });

    testWidgets('should update text when user types', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Email',
              hint: 'Enter email',
              controller: controller,
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField), 'test@test.com');

      // Assert
      expect(controller.text, 'test@test.com');
    });

    testWidgets('should show error text when provided', (WidgetTester tester) async {
      // Arrange
      const errorText = 'Invalid email';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Email',
              hint: 'Enter email',
              controller: TextEditingController(),
              errorText: errorText,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(errorText), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordTextField(
              label: 'Password',
              hint: 'Enter password',
              controller: TextEditingController(),
            ),
          ),
        ),
      );

      // Find text field
      final textFieldFinder = find.byType(TextField);
      TextField textField = tester.widget(textFieldFinder);

      // Assert initially obscured
      expect(textField.obscureText, true);

      // Act - tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      // Assert now visible
      textField = tester.widget(textFieldFinder);
      expect(textField.obscureText, false);

      // Act - tap again to hide
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Assert obscured again
      textField = tester.widget(textFieldFinder);
      expect(textField.obscureText, true);
    });
  });
}
```

### Example: Testing Screen with BLoC

**File:** `test/features/auth/presentation/screens/login_screen_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_state.dart';
import 'package:fpt_ojt/features/auth/presentation/screens/login_details_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<LoginDetailsBloc>()])
import 'login_screen_test.mocks.dart';

void main() {
  late MockLoginDetailsBloc mockBloc;

  setUp(() {
    mockBloc = MockLoginDetailsBloc();
    
    // Setup default state
    when(mockBloc.state).thenReturn(LoginDetailsInitial());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<LoginDetailsBloc>(
        create: (_) => mockBloc,
        child: child,
      ),
    );
  }

  group('LoginDetailsScreen', () {
    testWidgets('should render login form', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(makeTestableWidget(const LoginDetailsScreen()));

      // Assert
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should add LoginSubmitted event when login button tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(makeTestableWidget(const LoginDetailsScreen()));

      // Act - Enter credentials
      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'test@test.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'password123',
      );

      // Act - Tap login
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(1);
    });

    testWidgets('should show loading indicator when state is Loading',
        (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(LoginDetailsLoading());

      // Act
      await tester.pumpWidget(makeTestableWidget(const LoginDetailsScreen()));
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message when state is Error',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Invalid credentials';
      when(mockBloc.state).thenReturn(
        const LoginDetailsError(errorMessage),
      );

      // Act
      await tester.pumpWidget(makeTestableWidget(const LoginDetailsScreen()));
      await tester.pump();

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should navigate when state is Success',
        (WidgetTester tester) async {
      // Arrange
      final testUser = User(
        id: '1',
        name: 'Test',
        email: 'test@test.com',
        avatar: '',
      );

      when(mockBloc.state).thenReturn(LoginDetailsSuccess(testUser));

      // Act
      await tester.pumpWidget(makeTestableWidget(const LoginDetailsScreen()));
      await tester.pumpAndSettle();

      // Assert - verify navigation occurred
      // This depends on your routing implementation
    });
  });
}
```

### Testing Finder Patterns

```dart
// Find by text
expect(find.text('Login'), findsOneWidget);

// Find by type
expect(find.byType(TextField), findsNWidgets(2));

// Find by key
expect(find.byKey(const Key('login_button')), findsOneWidget);

// Find by icon
expect(find.byIcon(Icons.email), findsOneWidget);

// Find widget with specific text
expect(find.widgetWithText(ElevatedButton, 'Submit'), findsOneWidget);

// Find by descendant
expect(
  find.descendant(
    of: find.byType(AppBar),
    matching: find.text('Login'),
  ),
  findsOneWidget,
);
```

---

## Best Practices

### 1. Test Organization

- **One test file per source file**: `auth_bloc.dart` → `auth_bloc_test.dart`
- **Mirror directory structure**: Keep test structure identical to `lib/`
- **Use descriptive group names**: Group related tests logically
- **Use descriptive test names**: Use `should` or `when` prefixes

```dart
group('AuthBloc', () {
  group('AuthIsUserLoggedInEvent', () {
    blocTest('emits [Loading, LoggedIn] when user is authenticated', ...);
    blocTest('emits [Loading, Failure] when authentication fails', ...);
  });
});
```

### 2. Mock Management

```dart
// Always use @GenerateNiceMocks for type safety
@GenerateNiceMocks([
  MockSpec<YourDependency>(),
  MockSpec<AnotherDependency>(),
])

// Setup common mocks in setUp()
setUp(() {
  mockDependency = MockYourDependency();
  // Setup default behavior if needed
  when(mockDependency.someMethod()).thenReturn(defaultValue);
});

// Verify interactions explicitly
verify(mock.method(args)).called(1);
verifyNever(mock.anotherMethod());
verifyNoMoreInteractions(mock);
```

### 3. Test Data

```dart
// Create reusable test data
final testUser = User(
  id: '1',
  name: 'Test User',
  email: 'test@test.com',
  avatar: 'avatar.png',
);

final testFailure = Failure('Test error');

// Use const where possible
const testEmail = 'test@test.com';
const testPassword = 'password123';
```

### 4. Assertion Patterns

```dart
// Assert Either results
result.fold(
  (failure) => expect(failure.message, 'Expected error'),
  (success) => fail('Should have failed'),
);

// Assert state emissions
expect: () => [
  const LoadingState(),
  const SuccessState(data),
],

// Assert with matchers
expect(result, isA<Success>());
expect(list, hasLength(3));
expect(text, contains('error'));
```

### 5. Testing Async Code

```dart
// Use async/await
test('async test', () async {
  final result = await repository.getData();
  expect(result.isRight(), true);
});

// Use pumpAndSettle for animations
await tester.pumpAndSettle();

// Use pump with duration for specific delays
await tester.pump(const Duration(seconds: 1));
```

### 6. Common Pitfalls

❌ **Don't test implementation details**
```dart
// Bad
test('calls private method', () {
  // Testing private methods
});
```

✅ **Test public behavior**
```dart
// Good
test('returns user when login succeeds', () {
  // Testing observable behavior
});
```

❌ **Don't use real dependencies**
```dart
// Bad
final repository = AuthRepositoryImpl(
  authDataSource: AuthDataSourceImpl(), // Real implementation
);
```

✅ **Always mock dependencies**
```dart
// Good
final repository = AuthRepositoryImpl(
  authDataSource: mockAuthDataSource, // Mock
);
```

### 7. Code Coverage Goals

- **Minimum**: 80% overall coverage
- **BLoCs/Cubits**: 95%+ (critical business logic)
- **Repositories**: 90%+ (data handling)
- **UseCases**: 100% (simple, easy to cover)
- **UI/Widgets**: 70%+ (focus on critical flows)

### 8. CI/CD Integration

Add to your CI pipeline:

```yaml
# .github/workflows/test.yml
- name: Run tests
  run: flutter test --coverage

- name: Check coverage
  run: |
    flutter pub global activate coverage
    flutter pub global run coverage:format_coverage \
      --lcov --in=coverage --out=coverage/lcov.info \
      --report-on=lib
```

---

## Quick Reference

### Running Specific Tests

```bash
# Run all tests
flutter test

# Run specific file
flutter test test/features/auth/presentation/blocs/auth_bloc_test.dart

# Run tests with name pattern
flutter test --name "AuthBloc"

# Run with coverage
flutter test --coverage

# Watch mode (re-run on changes)
flutter test --watch
```

### Generating Mocks

```bash
# Generate mocks for all test files
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (re-generate on changes)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Debugging Tests

```dart
// Print during test
test('debug test', () {
  print('Debug value: $value');
  debugPrint('Debug output');
});

// Use only to run single test
test('only this test', () {
  // This test will run exclusively
}, skip: false);

// Skip test temporarily
test('skip this test', () {
  // This test will be skipped
}, skip: true);
```

---

## Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [bloc_test Package](https://pub.dev/packages/bloc_test)
- [Mockito Package](https://pub.dev/packages/mockito)
- [Flutter Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Test Coverage Best Practices](https://flutter.dev/docs/testing/code-coverage)

---

**Happy Testing! 🎯**
