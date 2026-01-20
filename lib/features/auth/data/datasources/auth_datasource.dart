import 'package:fpt_ojt/features/auth/data/models/login_reponse.dart';

abstract interface class AuthDataSource {
  Future<LoginResponse> loginWithEmail(String email, String password);
  Future<LoginResponse> loginWithGoogle(String idToken);
  Future<UserModel?> getCurrentUser(String token);
  Future<void> logout();
  Future<void> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String repeatPassword,
  });
}
