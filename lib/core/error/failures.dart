import 'package:dio/dio.dart';

class Failure {
  Failure([this.message = 'An unexpected error occurred,']);

  factory Failure.fromException(Exception exception) {
    switch (exception) {
      case final DioException e:
        return Failure(
          e.response?.data['message'] as String? ??
              'An unexpected error occurred',
        );
      default:
        return Failure(exception.toString());
    }
  }
  final String message;
}
