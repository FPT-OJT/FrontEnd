import 'package:fpt_ojt/features/ai/data/models/ai_message_model.dart';

abstract class AiDatasource {
  Future<AiMessageModel> genText({
    required String sessionId,
    required String userMessage,
    String? fullName,
    double? latitude,
    double? longitude,
  });
}
