import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/ai/domain/entities/ai_message.dart';
import 'package:fpt_ojt/features/ai/domain/repositories/ai_repository.dart';
import 'package:fpt_ojt/features/ai/domain/usecases/gen_text_stream_uc.dart';
import 'package:fpt_ojt/features/ai/domain/usecases/gen_text_uc.dart';
import 'package:fpt_ojt/features/ai/presentation/blocs/ai_chat/ai_chat_event.dart';
import 'package:fpt_ojt/features/ai/presentation/blocs/ai_chat/ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  AiChatBloc({
    required AiRepository aiRepository,
    required GenTextStreamUseCase genTextStreamUseCase,
  }) : _aiRepository = aiRepository,
       _genTextStreamUseCase = genTextStreamUseCase,
       super(const AiChatState(sessionId: '', messages: [])) {
    on<AiChatStarted>(_onStarted);
    on<AiChatMessageSent>(_onMessageSent);
    on<AiChatSuggestionTapped>(_onSuggestionTapped);
  }

  final AiRepository _aiRepository;
  final GenTextStreamUseCase _genTextStreamUseCase;

  void _onStarted(AiChatStarted event, Emitter<AiChatState> emit) {
    final sessionId = _aiRepository.generateSessionId();
    emit(state.copyWith(sessionId: sessionId, messages: []));
  }

  Future<void> _onMessageSent(
    AiChatMessageSent event,
    Emitter<AiChatState> emit,
  ) => _handleUserMessage(
    event.message,
    emit,
    fullName: event.fullName,
    latitude: event.latitude,
    longitude: event.longitude,
  );

  Future<void> _onSuggestionTapped(
    AiChatSuggestionTapped event,
    Emitter<AiChatState> emit,
  ) => _handleUserMessage(
    event.suggestion,
    emit,
    fullName: event.fullName,
    latitude: event.latitude,
    longitude: event.longitude,
  );

  Future<void> _handleUserMessage(
    String message,
    Emitter<AiChatState> emit, {
    String? fullName,
    double? latitude,
    double? longitude,
  }) async {
    final userMsg = AiMessage(
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    emit(
      state.copyWith(
        messages: [...state.messages, userMsg],
        isGenerating: true,
      ),
    );

    final buffer = StringBuffer();
    final botTimestamp = DateTime.now();

    try {
      await emit.forEach<String>(
        _genTextStreamUseCase(
          GenTextParams(
            sessionId: state.sessionId,
            userMessage: message,
            fullName: fullName,
            latitude: latitude,
            longitude: longitude,
          ),
        ),
        onData: (chunk) {
          buffer.write(chunk);
          final botMsg = AiMessage(
            content: buffer.toString(),
            isUser: false,
            timestamp: botTimestamp,
          );
          final messages = [...state.messages];
          if (messages.isNotEmpty && !messages.last.isUser) {
            messages[messages.length - 1] = botMsg;
          } else {
            messages.add(botMsg);
          }
          return state.copyWith(messages: messages, isGenerating: true);
        },
        onError: (error, _) => state.copyWith(
          isGenerating: false,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isGenerating: false, errorMessage: e.toString()));
      return;
    }

    emit(state.copyWith(isGenerating: false));
  }
}
