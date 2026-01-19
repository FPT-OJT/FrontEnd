import 'package:dio/dio.dart';

// TODO(hoang): Add interceptors, logging, and error handling.
class HttpClient {
  Dio createDioClient(String baseUrl) => Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
