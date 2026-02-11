import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/card/domain/repositories/card_repositories.dart';

class EditUserCardUsecase implements UseCase<bool, EditUserCardParams> {
  EditUserCardUsecase({required CardRepositories cardRepositories})
    : _cardRepositories = cardRepositories;
  final CardRepositories _cardRepositories;

  @override
  Future<Either<Failure, bool>> call(EditUserCardParams params) async =>
      _cardRepositories.editUserCard(
        params.cardId,
        params.firstPaymentDate,
        params.expiryDate,
      );
}

class EditUserCardParams extends Equatable {
  const EditUserCardParams({
    required this.cardId,
    this.firstPaymentDate,
    this.expiryDate,
  });

  final String cardId;
  final int? firstPaymentDate;
  final DateTime? expiryDate;

  @override
  List<Object?> get props => [cardId, firstPaymentDate, expiryDate];
}
