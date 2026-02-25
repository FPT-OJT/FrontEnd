import 'package:equatable/equatable.dart';

sealed class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => [];
}

class AiChatStarted extends AiChatEvent {
  const AiChatStarted();
}

class AiChatMessageSent extends AiChatEvent {
  const AiChatMessageSent({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class AiChatSuggestionTapped extends AiChatEvent {
  const AiChatSuggestionTapped({required this.suggestion});

  final String suggestion;

  @override
  List<Object?> get props => [suggestion];
}
