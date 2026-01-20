import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_exception.freezed.dart';
part 'server_exception.g.dart';

@freezed
abstract class ServerException with _$ServerException implements Exception {
  const ServerException._();

  const factory ServerException({
    int? statusCode,
    required String message,
    dynamic data,
    String? code,
    dynamic raw,
  }) = _ServerException;

  factory ServerException.fromMap(Map<String, dynamic> json) => ServerException(
    statusCode: json['statusCode'] as int?,
    message: (json['message'] as String?) ?? 'Server error',
    data: json['data'],
    raw: json,
    code: json['code']?.toString(),
  );

  factory ServerException.fromJson(Map<String, dynamic> json) =>
      _$ServerExceptionFromJson(json);

  @override
  String toString() => 'ServerException($statusCode, $code, $message)';
}
