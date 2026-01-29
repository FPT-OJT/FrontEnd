import 'dart:async';
import 'package:dio/dio.dart';

class TestErrorInterceptorHandler extends ErrorInterceptorHandler {
  final completer = Completer<void>();

  DioException? nextError;
  DioException? rejectedError;
  Response<dynamic>? resolvedResponse;

  @override
  void next(DioException err) {
    nextError = err;
    if (!completer.isCompleted) completer.complete();
  }

  @override
  void resolve(Response response) {
    resolvedResponse = response;
    if (!completer.isCompleted) completer.complete();
  }

  @override
  void reject(DioException err) {
    rejectedError = err;
    if (!completer.isCompleted) completer.complete();
  }
}
