import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/auth/data/datasources/auth_datasource.dart';
import 'package:fpt_ojt/features/auth/data/models/login_reponse.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl({required Dio dio}) : _dio = dio;
  final Dio _dio;
  @override
  Future<LoginResponse> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@test.com' && password == '123456') {
      return LoginResponse(
        user: UserModel(
          id: '1',
          name: 'Laffy',
          email: 'test@test.com',
          phone: '1234567890',
          address: '1234567890',
          avatar: 'https://via.placeholder.com/150',
          role: 'admin',
          status: 'active',
        ),
        token: 'token',
        refreshToken: 'refreshToken',
        tokenType: 'tokenType',
        scope: 'scope',
        idToken: 'idToken',
      );
    } else {
      throw Exception('Invalid email or password');
    }
  }

  @override
  Future<LoginResponse> loginWithGoogle(String idToken) async {
    await Future.delayed(const Duration(seconds: 1));
    return LoginResponse(
      user: UserModel(
        id: '1',
        name: 'Laffy',
        email: 'test@test.com',
        phone: '1234567890',
        address: '1234567890',
        avatar: 'https://via.placeholder.com/150',
        role: 'admin',
        status: 'active',
      ),
      token: 'token',
      refreshToken: 'refreshToken',
      tokenType: 'tokenType',
      scope: 'scope',
      idToken: 'idToken',
    );
  }

  @override
  Future<UserModel?> getCurrentUser(String token) async {
    await Future.delayed(const Duration(seconds: 1));
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
    // Mock delay cho logout API call
    await Future.delayed(const Duration(seconds: 2));
    // Simulate successful logout
    return;
  }

  @override
  Future<ApiResponse<String>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String repeatPassword,
  }) async {
    final payload = {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password,
      'repeatPassword': repeatPassword,
    };
    final response = await _dio.post<Map<String, dynamic>>(
      '/public/auth/register',
      data: payload,
    );
    return ApiResponse.fromJson(response.data ?? {}, (json) => json! as String);
  }
}
