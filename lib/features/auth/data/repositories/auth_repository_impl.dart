import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/common/token/token_store.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/auth/data/datasources/auth_datasource.dart';
import 'package:fpt_ojt/features/auth/data/datasources/google_auth_data_source.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthDataSource authDataSource,
    required GoogleAuthDataSource googleAuthDataSource,
    required TokenStore tokenDataSource,
  }) : _authDataSource = authDataSource,
       _googleAuthDataSource = googleAuthDataSource,
       _tokenDataSource = tokenDataSource;
  final AuthDataSource _authDataSource;
  final GoogleAuthDataSource _googleAuthDataSource;
  final TokenStore _tokenDataSource;
  @override
  Future<Either<Failure, User>> loginWithEmail(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    try {
      final response = await _authDataSource.loginWithEmail(
        email,
        password,
        rememberMe: rememberMe,
      );
      await _tokenDataSource.saveAccessToken(response.data!.accessToken);
      await _tokenDataSource.saveRefreshToken(
        response.data!.refreshToken,
        rememberMe: rememberMe,
      );
      return Right(
        User(
          id: response.data!.userId,
          name: response.data!.role,
          avatar: 'https://via.placeholder.com/150',
          email: 'test@test.com',
        ),
      );
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    try {
      final idToken = await _googleAuthDataSource.getIdToken();
      final response = await _authDataSource.loginWithGoogle(idToken);
      await _tokenDataSource.saveAccessToken(response.data!.accessToken);
      await _tokenDataSource.saveRefreshToken(
        response.data!.refreshToken,
        rememberMe: true,
      );
      return Right(
        User(
          id: response.data!.userId,
          name: response.data!.role,
          avatar: 'https://via.placeholder.com/150',
          email: 'test@test.com',
        ),
      );
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final token = await _tokenDataSource.getRefreshToken();
      print('token: $token');
      if (token.isEmpty) {
        return Left(Failure('User not logged in!'));
      }

      final user = await _authDataSource.getCurrentUser();
      if (user == null) {
        return Left(Failure('User not logged in!'));
      }

      return Right(
        User(
          id: user.id,
          name: user.name,
          avatar: user.avatar,
          email: user.email,
        ),
      );
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Call logout API endpoint (mock with delay)
      await _authDataSource.logout();

      // Clear tokens from local storage
      await _tokenDataSource.deleteAccessToken();
      await _tokenDataSource.deleteRefreshToken();

      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String repeatPassword,
    required String email,
  }) async {
    try {
      final response = await _authDataSource.register(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
        repeatPassword: repeatPassword,
        email: email,
      );
      return Right(
        User(
          id: response.data!.userId,
          name: response.data!.role,
          avatar: 'https://via.placeholder.com/150',
          email: 'test@test.com',
        ),
      );
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await _authDataSource.forgotPassword(email);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    try {
      await _authDataSource.resetPassword(email, otp, newPassword);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
