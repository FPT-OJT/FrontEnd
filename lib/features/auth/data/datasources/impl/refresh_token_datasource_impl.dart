import 'package:dio/dio.dart';
import 'package:fpt_ojt/core/common/token/refresh_token_datasource.dart';
import 'package:fpt_ojt/features/auth/data/models/auth_models.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

class RefreshTokenDataSourceImpl implements RefreshTokenDataSource {
  RefreshTokenDataSourceImpl({required Dio dio}) : _dio = dio;
  final Dio _dio;
  @override
  Future<(String?, String?)> refreshTokens(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/public/auth/refresh',
      options: Options(headers: {'X-Refresh-Token': refreshToken}),
    );

    final data = ApiResponse<TokenResponse>.fromJson(
      response.data ?? {},
      (json) => TokenResponse.fromJson(json! as Map<String, dynamic>),
    );
    return (data.data?.accessToken, data.data?.refreshToken);
  }
}
