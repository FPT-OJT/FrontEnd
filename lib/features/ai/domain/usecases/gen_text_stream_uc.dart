import 'package:fpt_ojt/features/ai/domain/repositories/ai_repository.dart';
import 'package:fpt_ojt/features/ai/domain/usecases/gen_text_uc.dart';

class GenTextStreamUseCase {
  GenTextStreamUseCase({required this.aiRepository});

  final AiRepository aiRepository;

  Stream<String> call(GenTextParams params) => aiRepository.genTextStream(
    sessionId: params.sessionId,
    userMessage: params.userMessage,
    fullName: params.fullName,
    latitude: params.latitude,
    longitude: params.longitude,
  );
}
