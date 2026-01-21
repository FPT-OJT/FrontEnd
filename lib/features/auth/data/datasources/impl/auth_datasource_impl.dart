import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/auth/data/datasources/auth_datasource.dart';
import 'package:fpt_ojt/features/auth/data/models/auth_models.dart';
import 'package:fpt_ojt/features/auth/data/models/login_reponse.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl({required Dio dio}) : _dio = dio;
  final Dio _dio;
  @override
  Future<ApiResponse<TokenResponse>> loginWithEmail(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/public/auth/login',
      data: {'username': email, 'password': password, 'rememberMe': rememberMe},
    );
    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => TokenResponse.fromJson(json! as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<TokenResponse>> loginWithGoogle(String idToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/public/auth/google?googleToken=$idToken',
    );
    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => TokenResponse.fromJson(json! as Map<String, dynamic>),
    );
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await _dio.get<Map<String, dynamic>>('/home/test');
    // TODO: Implement get current user
    return UserModel(
      id: '1',
      name: 'Laffy',
      email: 'test@test.com',
      phone: '1234567890',
      address: '1234567890',
      avatar: 'https://via.placeholder.com/150',
      role: 'admin',
      status: 'active',
    );
  }

  @override
  Future<void> logout() async {
    await _dio.post<Map<String, dynamic>>('/auth/logout');
  }

  @override
  Future<ApiResponse<TokenResponse>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String repeatPassword,
    required String email,
  }) async {
    final payload = {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password,
      'repeatPassword': repeatPassword,
      'email': email,
    };
    final response = await _dio.post<Map<String, dynamic>>(
      '/public/auth/register',
      data: payload,
    );
    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => TokenResponse.fromJson(json! as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> forgotPassword(String email) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/public/auth/password/forgot?email=$email',
    );
    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => json! as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResponse<void>> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/public/auth/password/reset',
      data: {'email': email, 'otp': otp, 'newPassword': newPassword},
    );
    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => json! as Map<String, dynamic>,
    );
  }
}
