import 'package:fpt_ojt/features/ai/data/models/ai_message_model.dart';
import 'package:fpt_ojt/features/ai/domain/entities/ai_message.dart';

extension AiMessageModelMapper on AiMessageModel {
  AiMessage toEntity() =>
      AiMessage(content: content, isUser: isUser, timestamp: timestamp);
}
