import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/card/domain/repositories/card_repositories.dart';

class AddCardToUserUsecase implements UseCase<String, AddCardToUserParams> {
  AddCardToUserUsecase({required CardRepositories cardRepositories})
    : _cardRepositories = cardRepositories;
  final CardRepositories _cardRepositories;

  @override
  Future<Either<Failure, String>> call(AddCardToUserParams params) async =>
      _cardRepositories.addCardToUser(params.cardId);
}

class AddCardToUserParams extends Equatable {
  const AddCardToUserParams({required this.cardId});

  final String cardId;

  @override
  List<Object?> get props => [cardId];
}
