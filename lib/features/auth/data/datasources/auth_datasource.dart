import 'package:fpt_ojt/features/auth/data/models/auth_models.dart';
import 'package:fpt_ojt/features/auth/data/models/login_reponse.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

abstract interface class AuthDataSource {
  Future<ApiResponse<TokenResponse>> loginWithEmail(
    String email,
    String password,
  );
  Future<ApiResponse<TokenResponse>> loginWithGoogle(String idToken);
  Future<UserModel?> getCurrentUser(String token);
  Future<void> logout();
  Future<ApiResponse<TokenResponse>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String repeatPassword,
    required String email,
  });
}
