import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/intro/domain/repositories/onboarding_repository.dart';

class EndOnboardingUseCase implements UseCase<Unit, NoParams> {
  EndOnboardingUseCase(this.onboardingRepository);
  final OnboardingRepository onboardingRepository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async =>
      onboardingRepository.setSeen();
}
