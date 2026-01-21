import 'package:fpt_ojt/features/auth/data/models/auth_models.dart';
import 'package:fpt_ojt/features/auth/data/models/login_reponse.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

abstract interface class AuthDataSource {
  Future<ApiResponse<TokenResponse>> loginWithEmail(
    String email,
    String password, {
    bool rememberMe = false,
  });
  Future<ApiResponse<TokenResponse>> loginWithGoogle(String idToken);
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
  Future<ApiResponse<TokenResponse>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String repeatPassword,
    required String email,
  });
  Future<ApiResponse<void>> forgotPassword(String email);
  Future<ApiResponse<void>> resetPassword(
    String email,
    String otp,
    String newPassword,
  );
}
