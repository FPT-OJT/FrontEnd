import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/auth/data/datasources/auth_datasource.dart';
import 'package:fpt_ojt/features/auth/data/datasources/google_auth_data_source.dart';
import 'package:fpt_ojt/features/auth/data/datasources/token_datasource.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthDataSource authDataSource,
    required GoogleAuthDataSource googleAuthDataSource,
    required TokenDataSource tokenDataSource,
  }) : _authDataSource = authDataSource,
       _googleAuthDataSource = googleAuthDataSource,
       _tokenDataSource = tokenDataSource;
  final AuthDataSource _authDataSource;
  final GoogleAuthDataSource _googleAuthDataSource;
  final TokenDataSource _tokenDataSource;
  @override
  Future<Either<Failure, User>> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      final response = await _authDataSource.loginWithEmail(email, password);
      await _tokenDataSource.saveAccessToken(response.data!.accessToken);
      await _tokenDataSource.saveRefreshToken(response.data!.refreshToken);
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
      await _tokenDataSource.saveRefreshToken(response.data!.refreshToken);
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
      final token = await _tokenDataSource.getAccessToken();
      if (token.isEmpty) {
        return Left(Failure('No access token found'));
      }

      final user = await _authDataSource.getCurrentUser(token);
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
}
