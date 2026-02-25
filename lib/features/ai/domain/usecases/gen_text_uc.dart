import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/ai/domain/entities/ai_message.dart';
import 'package:fpt_ojt/features/ai/domain/repositories/ai_repository.dart';

class GenTextUseCase implements UseCase<AiMessage, GenTextParams> {
  GenTextUseCase({required this.aiRepository});

  final AiRepository aiRepository;

  @override
  Future<Either<Failure, AiMessage>> call(GenTextParams params) => aiRepository
      .genText(sessionId: params.sessionId, userMessage: params.userMessage);
}

@immutable
class GenTextParams extends Equatable {
  const GenTextParams({required this.sessionId, required this.userMessage});

  final String sessionId;
  final String userMessage;

  @override
  List<Object?> get props => [sessionId, userMessage];
}
