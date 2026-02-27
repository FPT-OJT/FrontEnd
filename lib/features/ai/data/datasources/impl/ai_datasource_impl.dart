import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/ai/data/datasources/ai_datasource.dart';
import 'package:fpt_ojt/features/ai/data/models/ai_message_model.dart';

class AiDatasourceImpl implements AiDatasource {
  AiDatasourceImpl({required Dio dio}) : _dio = dio;
  final Dio _dio;
  @override
  Future<AiMessageModel> genText({
    required String sessionId,
    required String userMessage,
    String? fullName,
    double? latitude,
    double? longitude,
  }) async {
    final params = {
      'chatInput': userMessage,
      'sessionId': sessionId,
      'fullName': fullName,
      'lat': latitude,
      'long': longitude,
    };
    final response = await _dio.post<String>(
      '/api/ai/webhook/chat',
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
}
