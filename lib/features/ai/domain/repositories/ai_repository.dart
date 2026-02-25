import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/ai/domain/entities/ai_message.dart';

abstract class AiRepository {
  String generateSessionId();

  Future<Either<Failure, AiMessage>> genText({
    required String sessionId,
    required String userMessage,
    String? fullName,
    double? latitude,
    double? longitude,
  });
}
