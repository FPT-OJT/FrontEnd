import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';

abstract class OnboardingRepository {
  Future<bool> isSeen();
  Future<Either<Failure, Unit>> setSeen();
}
