import 'package:dio/dio.dart';
import 'package:fpt_ojt/core/common/token/refresh_token_datasource.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

class RefreshTokenDataSourceImpl implements RefreshTokenDataSource {
  RefreshTokenDataSourceImpl({required Dio dio}) : _dio = dio;
  final Dio _dio;
  @override
  Future<(String, String)> refreshTokens(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/public/auth/refresh',
      data: {'refreshToken': refreshToken},
    );

    final data = ApiResponse<String>.fromJson(
      response.data ?? {},
      (json) => json! as String,
    );
    return (data.data!, refreshToken);
  }
}
