import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/ai/domain/entities/ai_message.dart';
import 'package:fpt_ojt/features/ai/domain/repositories/ai_repository.dart';
import 'package:fpt_ojt/features/ai/domain/usecases/gen_text_uc.dart';
import 'package:fpt_ojt/features/ai/presentation/blocs/ai_chat/ai_chat_event.dart';
import 'package:fpt_ojt/features/ai/presentation/blocs/ai_chat/ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  AiChatBloc({
    required AiRepository aiRepository,
    required GenTextUseCase genTextUseCase,
  }) : _aiRepository = aiRepository,
       _genTextUseCase = genTextUseCase,
       super(const AiChatState(sessionId: '', messages: [])) {
    on<AiChatStarted>(_onStarted);
    on<AiChatMessageSent>(_onMessageSent);
    on<AiChatSuggestionTapped>(_onSuggestionTapped);
  }

  final AiRepository _aiRepository;
  final GenTextUseCase _genTextUseCase;

  void _onStarted(AiChatStarted event, Emitter<AiChatState> emit) {
    final sessionId = _aiRepository.generateSessionId();
    emit(state.copyWith(sessionId: sessionId, messages: []));
  }

  Future<void> _onMessageSent(
    AiChatMessageSent event,
    Emitter<AiChatState> emit,
  ) => _handleUserMessage(event.message, emit);

  Future<void> _onSuggestionTapped(
    AiChatSuggestionTapped event,
    Emitter<AiChatState> emit,
  ) => _handleUserMessage(event.suggestion, emit);

  Future<void> _handleUserMessage(
    String message,
    Emitter<AiChatState> emit,
  ) async {
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

    final result = await _genTextUseCase(
      GenTextParams(sessionId: state.sessionId, userMessage: message),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isGenerating: false, errorMessage: failure.message),
      ),
      (botMsg) => emit(
        state.copyWith(
          messages: [...state.messages, botMsg],
          isGenerating: false,
        ),
      ),
    );
  }
}
