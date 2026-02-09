import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/common/token/token_store.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/storages/key_value_storage.dart';
import 'package:fpt_ojt/features/auth/data/datasources/auth_datasource.dart';
import 'package:fpt_ojt/features/auth/data/datasources/google_auth_data_source.dart';
import 'package:fpt_ojt/features/auth/data/models/login_reponse.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
import 'package:fpt_ojt/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthDataSource authDataSource,
    required GoogleAuthDataSource googleAuthDataSource,
    required TokenStore tokenDataSource,
    required KeyValueStorage localStorage,
  }) : _authDataSource = authDataSource,
       _googleAuthDataSource = googleAuthDataSource,
       _tokenDataSource = tokenDataSource,
       _localStorage = localStorage;
  final AuthDataSource _authDataSource;
  final GoogleAuthDataSource _googleAuthDataSource;
  final TokenStore _tokenDataSource;
  final KeyValueStorage _localStorage;

  static const String _userCacheKey = 'cached_user_info';

  // Save user to local storage
  Future<void> _saveUserToCache(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _localStorage.set(_userCacheKey, userJson);
    } catch (_) {
      // Ignore cache errors
    }
  }

  // Get user from local storage
  Future<UserModel?> _getUserFromCache() async {
    try {
      final userJson = await _localStorage.get<String>(_userCacheKey);
      if (userJson == null) return null;
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (_) {
      return null;
    }
  }

  // Clear user cache
  Future<void> _clearUserCache() async {
    try {
      await _localStorage.remove(_userCacheKey);
    } catch (_) {
      // Ignore cache errors
    }
  }

  // Convert UserModel to User entity
  User _userModelToEntity(UserModel user) => User(
    id: user.id,
    firstName: user.firstName,
    lastName: user.lastName,
    avatar: '',
    email: user.email,
  );

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

      // Fetch and cache user info after login
      final user = await _authDataSource.getCurrentUser();
      if (user != null) {
        await _saveUserToCache(user);
        return Right(_userModelToEntity(user));
      }

      return Left(Failure('Failed to fetch user info'));
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

      // Fetch and cache user info after login
      final user = await _authDataSource.getCurrentUser();
      if (user != null) {
        await _saveUserToCache(user);
        return Right(_userModelToEntity(user));
      }

      return Left(Failure('Failed to fetch user info'));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final token = await _tokenDataSource.getRefreshToken();
      if (token.isEmpty) {
        return Left(Failure('User not logged in!'));
      }

      // Try to get from API first
      try {
        final user = await _authDataSource.getCurrentUser();
        if (user != null) {
          // Update cache with fresh data
          await _saveUserToCache(user);
          return Right(_userModelToEntity(user));
        }
      } on Exception catch (e) {
        // If it's an authentication error, clear cache and return auth failure
        final failure = Failure.fromException(e);
        if (failure is AuthenticationFailure) {
          await _clearUserCache();
          return Left(failure);
        }

        // If API fails for other reasons, try to get from cache
        final cachedUser = await _getUserFromCache();
        if (cachedUser != null) {
          return Right(_userModelToEntity(cachedUser));
        }
      }

      return Left(Failure('User not logged in!'));
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

      // Clear user cache
      await _clearUserCache();

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
          firstName: '',
          lastName: '',
          avatar: '',
          email: '',
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
