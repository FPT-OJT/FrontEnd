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
  Future<Either<Failure, AiMessage>> call(GenTextParams params) =>
      aiRepository.genText(
        sessionId: params.sessionId,
        userMessage: params.userMessage,
        fullName: params.fullName,
        latitude: params.latitude,
        longitude: params.longitude,
      );
}

@immutable
class GenTextParams extends Equatable {
  const GenTextParams({
    required this.sessionId,
    required this.userMessage,
    this.fullName,
    this.latitude,
    this.longitude,
  });

  final String sessionId;
  final String userMessage;
  final String? fullName;
  final double? latitude;
  final double? longitude;

  @override
  List<Object?> get props => [sessionId, userMessage];
}
