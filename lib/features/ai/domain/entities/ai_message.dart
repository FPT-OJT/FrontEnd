import 'package:equatable/equatable.dart';

class AiMessage extends Equatable {
  const AiMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  final String content;
  final bool isUser;
  final DateTime timestamp;

  @override
  List<Object?> get props => [content, isUser, timestamp];
}
