import 'package:dio/dio.dart';

class HttpClient {
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

    return dio;
  }
}
