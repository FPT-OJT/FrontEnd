import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> loginWithEmail(String email, String password);
  Future<Either<Failure, User>> loginWithGoogle();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String repeatPassword,
    required String email,
  });
}
