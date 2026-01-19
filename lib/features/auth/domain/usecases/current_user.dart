import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';

class CurrentUserUseCase implements UseCase<User, NoParams> {
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    throw UnimplementedError();
  }
}
