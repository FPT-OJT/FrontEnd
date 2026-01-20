import 'package:dio/dio.dart';
import 'package:fpt_ojt/core/common/token/refresh_token_datasource.dart';
import 'package:fpt_ojt/core/common/token/token_store.dart';
import 'package:fpt_ojt/core/network/auth_refresh_interceptor.dart';

class HttpClient {
  HttpClient({
    required TokenStore tokenStore,
    required RefreshTokenDataSource refreshTokenDataSource,
  }) : _tokenStore = tokenStore,
       _refreshTokenDataSource = refreshTokenDataSource;
  final TokenStore _tokenStore;
  final RefreshTokenDataSource _refreshTokenDataSource;
  Dio createDioClient(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        logPrint: print,
      ),
    );
    dio.interceptors.add(
      AuthRefreshInterceptor(
        dio: dio,
        tokenStore: _tokenStore,
        refreshDataSource: _refreshTokenDataSource,
      ),
    );

    return dio;
  }
}
