import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/ai/domain/entities/ai_message.dart';

class AiChatState extends Equatable {
  const AiChatState({
    required this.sessionId,
    required this.messages,
    this.isGenerating = false,
    this.errorMessage,
  });

  final String sessionId;
  final List<AiMessage> messages;
  final bool isGenerating;
  final String? errorMessage;

  AiChatState copyWith({
    String? sessionId,
    List<AiMessage>? messages,
    bool? isGenerating,
    String? errorMessage,
  }) => AiChatState(
    sessionId: sessionId ?? this.sessionId,
    messages: messages ?? this.messages,
    isGenerating: isGenerating ?? this.isGenerating,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [sessionId, messages, isGenerating, errorMessage];
}
