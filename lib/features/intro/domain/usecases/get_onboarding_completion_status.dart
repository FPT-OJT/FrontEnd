import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/intro/domain/repositories/onboarding_repository.dart';

class GetOnboardingCompletionStatusUseCase implements UseCase<bool, NoParams> {
  GetOnboardingCompletionStatusUseCase(this.onboardingRepository);
  final OnboardingRepository onboardingRepository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final result = await onboardingRepository.isSeen();
      return right(result);
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
