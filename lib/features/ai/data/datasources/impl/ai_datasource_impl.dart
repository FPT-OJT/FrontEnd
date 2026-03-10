import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/ai/data/datasources/ai_datasource.dart';
import 'package:fpt_ojt/features/ai/data/models/ai_message_model.dart';

class AiDatasourceImpl implements AiDatasource {
  AiDatasourceImpl({required Dio dio}) : _dio = dio;
  final Dio _dio;
  @override
  @Deprecated('Use genTextStream instead')
  Future<AiMessageModel> genText({
    required String sessionId,
    required String userMessage,
    String? fullName,
    double? latitude,
    double? longitude,
  }) async {
    // @Deprecated because now api return plain text
    final params = {
      'chatInput': userMessage,
      'sessionId': sessionId,
      'fullName': fullName,
      'lat': latitude,
      'long': longitude,
    };
    final response = await _dio.post<String>(
      '/api/ai/chat',
      data: params,
      options: Options(
        sendTimeout: const Duration(minutes: 10),
        receiveTimeout: const Duration(minutes: 10),
      ),
    );
    return AiMessageModel(
      content: response.data ?? '',
      isUser: false,
      timestamp: DateTime.now(),
    );
  }

  @override
  Stream<String> genTextStream({
    required String sessionId,
    required String userMessage,
    String? fullName,
    double? latitude,
    double? longitude,
  }) async* {
    final params = {
      'chatInput': userMessage,
      'sessionId': sessionId,
      'fullName': fullName,
      'lat': latitude,
      'long': longitude,
    };

    final response = await _dio.post(
      '/api/ai/chat',
      data: params,
      options: Options(
        responseType: ResponseType.stream,
        headers: {
          'Accept': 'text/event-stream',
          'Cache-Control': 'no-cache',
          'Connection': 'keep-alive',
        },
      ),
    );

    final responseBody = response.data as ResponseBody;

    String buffer = '';
    String currentEventType = '';

    await for (final chunk in responseBody.stream) {
      buffer += utf8.decode(chunk);

      final lines = buffer.split('\n');

      // keep the last incomplete line in the buffer
      buffer = lines.removeLast();

      for (final line in lines) {
        if (line.startsWith('event:')) {
          currentEventType = line.substring(6).trim();
        } else if (line.startsWith('data:')) {
          final data = line.substring(5).trim();

          if (data == '[DONE]') return;

          if (currentEventType == 'error') {
            final errorJson = jsonDecode(data) as Map<String, dynamic>;
            throw Exception(errorJson['error'] ?? 'Unknown error');
          }

          final parsed = jsonDecode(data) as Map<String, dynamic>;
          final choices = parsed['choices'] as List<dynamic>;
          if (choices.isNotEmpty) {
            final delta = choices[0]['delta'] as Map<String, dynamic>;
            final content = delta['content'] as String? ?? '';
            if (content.isNotEmpty) {
              yield content;
            }
          }
        } else if (line.trim().isEmpty) {
          currentEventType = '';
        }
      }
    }
  }
}
