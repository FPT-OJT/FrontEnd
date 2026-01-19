import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
