import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/ai/data/datasources/ai_datasource.dart';
import 'package:fpt_ojt/features/ai/data/mappers/ai_message_mapper.dart';
import 'package:fpt_ojt/features/ai/domain/entities/ai_message.dart';
import 'package:fpt_ojt/features/ai/domain/repositories/ai_repository.dart';
import 'package:uuid/uuid.dart';

class AiRepositoryImpl implements AiRepository {
  AiRepositoryImpl({required this.aiDatasource});

  final AiDatasource aiDatasource;

  @override
  String generateSessionId() => const Uuid().v4();

  @override
  Future<Either<Failure, AiMessage>> genText({
    required String sessionId,
    required String userMessage,
    String? fullName,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final model = await aiDatasource.genText(
        sessionId: sessionId,
        userMessage: userMessage,
        fullName: fullName,
        latitude: latitude,
        longitude: longitude,
      );
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
