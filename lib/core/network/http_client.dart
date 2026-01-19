import 'package:dio/dio.dart';

// TODO: Add interceptors, logging, error handling, etc.
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
