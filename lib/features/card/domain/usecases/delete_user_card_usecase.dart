import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/card/domain/repositories/card_repositories.dart';

class DeleteUserCardUsecase implements UseCase<bool, DeleteUserCardParams> {
  DeleteUserCardUsecase({required CardRepositories cardRepositories})
    : _cardRepositories = cardRepositories;
  final CardRepositories _cardRepositories;

  @override
  Future<Either<Failure, bool>> call(DeleteUserCardParams params) async =>
      _cardRepositories.deleteUserCard(params.userCardId);
}

class DeleteUserCardParams extends Equatable {
  const DeleteUserCardParams({required this.userCardId});

  final String userCardId;

  @override
  List<Object?> get props => [userCardId];
}
