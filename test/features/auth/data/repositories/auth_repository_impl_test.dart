import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/common/token/token_store.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/auth/data/datasources/auth_datasource.dart';
import 'package:fpt_ojt/features/auth/data/datasources/google_auth_data_source.dart';
import 'package:fpt_ojt/features/auth/data/models/auth_models.dart';
import 'package:fpt_ojt/features/auth/data/models/login_reponse.dart';
import 'package:fpt_ojt/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';
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

    final tokenResponse = const TokenResponse(
      accessToken: 'access_token_123',
      refreshToken: 'refresh_token_456',
      userId: 'user_1',
      role: 'USER',
    );

    final apiResponse = ApiResponse<TokenResponse>(
      statusCode: 200,
      message: 'Login successful',
      data: tokenResponse,
    );

    test('should save tokens and return User on success', () async {
      // Arrange
      when(
        mockAuthDataSource.loginWithEmail(
          email,
          password,
          rememberMe: rememberMe,
        ),
      ).thenAnswer((_) async => apiResponse);

      when(mockTokenStore.saveAccessToken(any)).thenAnswer((_) async => {});
      when(
        mockTokenStore.saveRefreshToken(
          any,
          rememberMe: anyNamed('rememberMe'),
        ),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.loginWithEmail(
        email,
        password,
        rememberMe: rememberMe,
      );

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should return Right'), (user) {
        expect(user.id, 'user_1');
        expect(user.name, 'USER');
        expect(user.avatar, 'https://via.placeholder.com/150');
        expect(user.email, 'test@test.com');
      });

      verify(
        mockAuthDataSource.loginWithEmail(
          email,
          password,
          rememberMe: rememberMe,
        ),
      ).called(1);
      verify(mockTokenStore.saveAccessToken('access_token_123')).called(1);
      verify(
        mockTokenStore.saveRefreshToken(
          'refresh_token_456',
          rememberMe: rememberMe,
        ),
      ).called(1);
    });

    test(
      'should save tokens with rememberMe false when not specified',
      () async {
        // Arrange
        when(
          mockAuthDataSource.loginWithEmail(email, password, rememberMe: false),
        ).thenAnswer((_) async => apiResponse);

        when(mockTokenStore.saveAccessToken(any)).thenAnswer((_) async => {});
        when(
          mockTokenStore.saveRefreshToken(
            any,
            rememberMe: anyNamed('rememberMe'),
          ),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.loginWithEmail(email, password);

        // Assert
        expect(result.isRight(), true);
        verify(
          mockTokenStore.saveRefreshToken(
            'refresh_token_456',
            rememberMe: false,
          ),
        ).called(1);
      },
    );

    test('should return Failure when datasource throws exception', () async {
      // Arrange
      when(
        mockAuthDataSource.loginWithEmail(
          email,
          password,
          rememberMe: rememberMe,
        ),
      ).thenThrow(Exception('Network error'));

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
      verifyNever(
        mockTokenStore.saveRefreshToken(
          any,
          rememberMe: anyNamed('rememberMe'),
        ),
      );
    });

    test('should return Failure when saving tokens fails', () async {
      // Arrange
      when(
        mockAuthDataSource.loginWithEmail(
          email,
          password,
          rememberMe: rememberMe,
        ),
      ).thenAnswer((_) async => apiResponse);
      when(
        mockTokenStore.saveAccessToken(any),
      ).thenThrow(Exception('Storage error'));

      // Act
      final result = await repository.loginWithEmail(
        email,
        password,
        rememberMe: rememberMe,
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Storage error')),
        (user) => fail('Should return Left'),
      );
    });
  });

  group('loginWithGoogle', () {
    const idToken = 'google_id_token_123';

    final tokenResponse = const TokenResponse(
      accessToken: 'access_token_google',
      refreshToken: 'refresh_token_google',
      userId: 'google_user_1',
      role: 'USER',
    );

    final apiResponse = ApiResponse<TokenResponse>(
      statusCode: 200,
      message: 'Google login successful',
      data: tokenResponse,
    );

    test(
      'should get id token, save tokens and return User on success',
      () async {
        // Arrange
        when(
          mockGoogleAuthDataSource.getIdToken(),
        ).thenAnswer((_) async => idToken);
        when(
          mockAuthDataSource.loginWithGoogle(idToken),
        ).thenAnswer((_) async => apiResponse);
        when(mockTokenStore.saveAccessToken(any)).thenAnswer((_) async => {});
        when(
          mockTokenStore.saveRefreshToken(
            any,
            rememberMe: anyNamed('rememberMe'),
          ),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.loginWithGoogle();

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should return Right'), (user) {
          expect(user.id, 'google_user_1');
          expect(user.name, 'USER');
          expect(user.avatar, 'https://via.placeholder.com/150');
          expect(user.email, 'test@test.com');
        });

        verify(mockGoogleAuthDataSource.getIdToken()).called(1);
        verify(mockAuthDataSource.loginWithGoogle(idToken)).called(1);
        verify(mockTokenStore.saveAccessToken('access_token_google')).called(1);
        verify(
          mockTokenStore.saveRefreshToken(
            'refresh_token_google',
            rememberMe: true,
          ),
        ).called(1);
      },
    );

    test('should always set rememberMe to true for Google login', () async {
      // Arrange
      when(
        mockGoogleAuthDataSource.getIdToken(),
      ).thenAnswer((_) async => idToken);
      when(
        mockAuthDataSource.loginWithGoogle(idToken),
      ).thenAnswer((_) async => apiResponse);
      when(mockTokenStore.saveAccessToken(any)).thenAnswer((_) async => {});
      when(
        mockTokenStore.saveRefreshToken(
          any,
          rememberMe: anyNamed('rememberMe'),
        ),
      ).thenAnswer((_) async => {});

      // Act
      await repository.loginWithGoogle();

      // Assert
      verify(mockTokenStore.saveRefreshToken(any, rememberMe: true)).called(1);
    });

    test('should return Failure when getIdToken fails', () async {
      // Arrange
      when(
        mockGoogleAuthDataSource.getIdToken(),
      ).thenThrow(Exception('Google Sign In cancelled'));

      // Act
      final result = await repository.loginWithGoogle();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) =>
            expect(failure.message, contains('Google Sign In cancelled')),
        (user) => fail('Should return Left'),
      );

      verifyNever(mockAuthDataSource.loginWithGoogle(any));
      verifyNever(mockTokenStore.saveAccessToken(any));
    });

    test('should return Failure when loginWithGoogle API fails', () async {
      // Arrange
      when(
        mockGoogleAuthDataSource.getIdToken(),
      ).thenAnswer((_) async => idToken);
      when(
        mockAuthDataSource.loginWithGoogle(idToken),
      ).thenThrow(Exception('Invalid Google token'));

      // Act
      final result = await repository.loginWithGoogle();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Invalid Google token')),
        (user) => fail('Should return Left'),
      );

      verifyNever(mockTokenStore.saveAccessToken(any));
    });
  });

  group('getCurrentUser', () {
    final userModel = UserModel(
      id: '1',
      name: 'John Doe',
      email: 'john@test.com',
      phone: '1234567890',
      address: '123 Main St',
      avatar: 'https://example.com/avatar.png',
      role: 'USER',
      status: 'active',
    );

    test(
      'should return User when token exists and user data is valid',
      () async {
        // Arrange
        const refreshToken = 'valid_refresh_token';

        when(
          mockTokenStore.getRefreshToken(),
        ).thenAnswer((_) async => refreshToken);
        when(
          mockAuthDataSource.getCurrentUser(),
        ).thenAnswer((_) async => userModel);

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should return Right'), (user) {
          expect(user.id, '1');
          expect(user.name, 'John Doe');
          expect(user.email, 'john@test.com');
          expect(user.avatar, 'https://example.com/avatar.png');
        });

        verify(mockTokenStore.getRefreshToken()).called(1);
        verify(mockAuthDataSource.getCurrentUser()).called(1);
      },
    );

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

      verify(mockTokenStore.getRefreshToken()).called(1);
      verifyNever(mockAuthDataSource.getCurrentUser());
    });

    test('should return Failure when user data is null', () async {
      // Arrange
      when(
        mockTokenStore.getRefreshToken(),
      ).thenAnswer((_) async => 'valid_token');
      when(mockAuthDataSource.getCurrentUser()).thenAnswer((_) async => null);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'User not logged in!'),
        (user) => fail('Should return Left'),
      );

      verify(mockTokenStore.getRefreshToken()).called(1);
      verify(mockAuthDataSource.getCurrentUser()).called(1);
    });

    test(
      'should return Failure when getRefreshToken throws exception',
      () async {
        // Arrange
        when(
          mockTokenStore.getRefreshToken(),
        ).thenThrow(Exception('Storage error'));

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('Storage error')),
          (user) => fail('Should return Left'),
        );

        verifyNever(mockAuthDataSource.getCurrentUser());
      },
    );

    test(
      'should return Failure when getCurrentUser throws exception',
      () async {
        // Arrange
        when(
          mockTokenStore.getRefreshToken(),
        ).thenAnswer((_) async => 'valid_token');
        when(
          mockAuthDataSource.getCurrentUser(),
        ).thenThrow(Exception('Network error'));

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('Network error')),
          (user) => fail('Should return Left'),
        );
      },
    );
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

    test('should verify logout is called before clearing tokens', () async {
      // Arrange
      when(mockAuthDataSource.logout()).thenAnswer((_) async => {});
      when(mockTokenStore.deleteAccessToken()).thenAnswer((_) async => {});
      when(mockTokenStore.deleteRefreshToken()).thenAnswer((_) async => {});

      // Act
      await repository.logout();

      // Assert - verify order of operations
      verifyInOrder([
        mockAuthDataSource.logout(),
        mockTokenStore.deleteAccessToken(),
        mockTokenStore.deleteRefreshToken(),
      ]);
    });

    test('should return Failure when logout API fails', () async {
      // Arrange
      when(mockAuthDataSource.logout()).thenThrow(Exception('Server error'));

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Server error')),
        (_) => fail('Should return Left'),
      );

      verify(mockAuthDataSource.logout()).called(1);
      verifyNever(mockTokenStore.deleteAccessToken());
      verifyNever(mockTokenStore.deleteRefreshToken());
    });

    test('should return Failure when deleteAccessToken fails', () async {
      // Arrange
      when(mockAuthDataSource.logout()).thenAnswer((_) async => {});
      when(
        mockTokenStore.deleteAccessToken(),
      ).thenThrow(Exception('Storage error'));

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Storage error')),
        (_) => fail('Should return Left'),
      );

      verify(mockAuthDataSource.logout()).called(1);
      verify(mockTokenStore.deleteAccessToken()).called(1);
      verifyNever(mockTokenStore.deleteRefreshToken());
    });
  });

  group('register', () {
    const firstName = 'John';
    const lastName = 'Doe';
    const username = 'johndoe';
    const password = 'password123';
    const repeatPassword = 'password123';
    const email = 'john@test.com';

    final tokenResponse = const TokenResponse(
      accessToken: 'access_token_new',
      refreshToken: 'refresh_token_new',
      userId: 'new_user_1',
      role: 'USER',
    );

    final apiResponse = ApiResponse<TokenResponse>(
      statusCode: 201,
      message: 'Registration successful',
      data: tokenResponse,
    );

    test('should return User on successful registration', () async {
      // Arrange
      when(
        mockAuthDataSource.register(
          firstName: firstName,
          lastName: lastName,
          username: username,
          password: password,
          repeatPassword: repeatPassword,
          email: email,
        ),
      ).thenAnswer((_) async => apiResponse);

      // Act
      final result = await repository.register(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
        repeatPassword: repeatPassword,
        email: email,
      );

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should return Right'), (user) {
        expect(user.id, 'new_user_1');
        expect(user.name, 'USER');
        expect(user.avatar, 'https://via.placeholder.com/150');
        expect(user.email, 'test@test.com');
      });

      verify(
        mockAuthDataSource.register(
          firstName: firstName,
          lastName: lastName,
          username: username,
          password: password,
          repeatPassword: repeatPassword,
          email: email,
        ),
      ).called(1);
    });

    test(
      'should return Failure when registration fails with validation error',
      () async {
        // Arrange
        when(
          mockAuthDataSource.register(
            firstName: firstName,
            lastName: lastName,
            username: username,
            password: password,
            repeatPassword: repeatPassword,
            email: email,
          ),
        ).thenThrow(Exception('Email already exists'));

        // Act
        final result = await repository.register(
          firstName: firstName,
          lastName: lastName,
          username: username,
          password: password,
          repeatPassword: repeatPassword,
          email: email,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) =>
              expect(failure.message, contains('Email already exists')),
          (user) => fail('Should return Left'),
        );
      },
    );

    test('should return Failure when passwords do not match', () async {
      // Arrange
      when(
        mockAuthDataSource.register(
          firstName: firstName,
          lastName: lastName,
          username: username,
          password: password,
          repeatPassword: 'different_password',
          email: email,
        ),
      ).thenThrow(Exception('Passwords do not match'));

      // Act
      final result = await repository.register(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
        repeatPassword: 'different_password',
        email: email,
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) =>
            expect(failure.message, contains('Passwords do not match')),
        (user) => fail('Should return Left'),
      );
    });

    test('should return Failure when network error occurs', () async {
      // Arrange
      when(
        mockAuthDataSource.register(
          firstName: firstName,
          lastName: lastName,
          username: username,
          password: password,
          repeatPassword: repeatPassword,
          email: email,
        ),
      ).thenThrow(Exception('Network timeout'));

      // Act
      final result = await repository.register(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
        repeatPassword: repeatPassword,
        email: email,
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Network timeout')),
        (user) => fail('Should return Left'),
      );
    });
  });

  group('forgotPassword', () {
    const email = 'test@test.com';

    final apiResponse = const ApiResponse<void>(
      statusCode: 200,
      message: 'Password reset email sent',
      data: null,
    );

    test('should return Right when forgotPassword succeeds', () async {
      // Arrange
      when(
        mockAuthDataSource.forgotPassword(email),
      ).thenAnswer((_) async => apiResponse);

      // Act
      final result = await repository.forgotPassword(email);

      // Assert
      expect(result.isRight(), true);
      verify(mockAuthDataSource.forgotPassword(email)).called(1);
    });

    test('should return Failure when email is not found', () async {
      // Arrange
      when(
        mockAuthDataSource.forgotPassword(email),
      ).thenThrow(Exception('Email not found'));

      // Act
      final result = await repository.forgotPassword(email);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Email not found')),
        (_) => fail('Should return Left'),
      );
    });

    test('should return Failure when network error occurs', () async {
      // Arrange
      when(
        mockAuthDataSource.forgotPassword(email),
      ).thenThrow(Exception('Network error'));

      // Act
      final result = await repository.forgotPassword(email);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Network error')),
        (_) => fail('Should return Left'),
      );
    });

    test('should call datasource with correct email', () async {
      // Arrange
      const testEmail = 'unique@test.com';
      when(
        mockAuthDataSource.forgotPassword(testEmail),
      ).thenAnswer((_) async => apiResponse);

      // Act
      await repository.forgotPassword(testEmail);

      // Assert
      verify(mockAuthDataSource.forgotPassword(testEmail)).called(1);
      verifyNever(mockAuthDataSource.forgotPassword(argThat(isNot(testEmail))));
    });
  });

  group('resetPassword', () {
    const email = 'test@test.com';
    const otp = '123456';
    const newPassword = 'newPassword123';

    final apiResponse = const ApiResponse<void>(
      statusCode: 200,
      message: 'Password reset successful',
      data: null,
    );

    test('should return Right when resetPassword succeeds', () async {
      // Arrange
      when(
        mockAuthDataSource.resetPassword(email, otp, newPassword),
      ).thenAnswer((_) async => apiResponse);

      // Act
      final result = await repository.resetPassword(email, otp, newPassword);

      // Assert
      expect(result.isRight(), true);
      verify(
        mockAuthDataSource.resetPassword(email, otp, newPassword),
      ).called(1);
    });

    test('should call datasource with correct parameters', () async {
      // Arrange
      when(
        mockAuthDataSource.resetPassword(email, otp, newPassword),
      ).thenAnswer((_) async => apiResponse);

      // Act
      await repository.resetPassword(email, otp, newPassword);

      // Assert
      verify(
        mockAuthDataSource.resetPassword(email, otp, newPassword),
      ).called(1);
      verifyNoMoreInteractions(mockAuthDataSource);
    });

    test('should return Failure when OTP is invalid', () async {
      // Arrange
      when(
        mockAuthDataSource.resetPassword(email, otp, newPassword),
      ).thenThrow(Exception('Invalid OTP'));

      // Act
      final result = await repository.resetPassword(email, otp, newPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Invalid OTP')),
        (_) => fail('Should return Left'),
      );
    });

    test('should return Failure when OTP is expired', () async {
      // Arrange
      when(
        mockAuthDataSource.resetPassword(email, otp, newPassword),
      ).thenThrow(Exception('OTP expired'));

      // Act
      final result = await repository.resetPassword(email, otp, newPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('OTP expired')),
        (_) => fail('Should return Left'),
      );
    });

    test('should return Failure when new password is invalid', () async {
      // Arrange
      const weakPassword = '123';
      when(
        mockAuthDataSource.resetPassword(email, otp, weakPassword),
      ).thenThrow(Exception('Password too weak'));

      // Act
      final result = await repository.resetPassword(email, otp, weakPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Password too weak')),
        (_) => fail('Should return Left'),
      );
    });

    test('should return Failure when network error occurs', () async {
      // Arrange
      when(
        mockAuthDataSource.resetPassword(email, otp, newPassword),
      ).thenThrow(Exception('Network timeout'));

      // Act
      final result = await repository.resetPassword(email, otp, newPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Network timeout')),
        (_) => fail('Should return Left'),
      );
    });
  });
}
