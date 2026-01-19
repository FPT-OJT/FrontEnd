import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';

class GetIsOnboardingUseCase implements UseCase<bool, NoParams> {
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    //TODO(hoang): Implement the logic to get onboarding status
    throw UnimplementedError();
  }
}
