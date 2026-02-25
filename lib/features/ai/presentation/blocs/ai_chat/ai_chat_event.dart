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
  const AiChatMessageSent({required this.message, this.fullName, this.latitude, this.longitude});

  final String message;
  final String? fullName;
  final double? latitude;
  final double? longitude;

  @override
  List<Object?> get props => [message];
}

class AiChatSuggestionTapped extends AiChatEvent {
  const AiChatSuggestionTapped({required this.suggestion, this.fullName, this.latitude, this.longitude});

  final String suggestion;
  final String? fullName;
  final double? latitude;
  final double? longitude;
  @override
  List<Object?> get props => [suggestion];
}
