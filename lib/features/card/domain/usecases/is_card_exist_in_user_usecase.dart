import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/card/domain/repositories/card_repositories.dart';

class IsCardExistInUserUsecase
    implements UseCase<bool, IsCardExistInUserParams> {
  IsCardExistInUserUsecase({required CardRepositories cardRepositories})
    : _cardRepositories = cardRepositories;
  final CardRepositories _cardRepositories;

  @override
  Future<Either<Failure, bool>> call(IsCardExistInUserParams params) async =>
      _cardRepositories.isCardExistInUser(params.cardId);
}

class IsCardExistInUserParams extends Equatable {
  const IsCardExistInUserParams({required this.cardId});

  final String cardId;

  @override
  List<Object?> get props => [cardId];
}
