import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/card/domain/entities/card_entity.dart';

abstract interface class CardRepositories {
  Future<Either<Failure, List<CardEntity>>> searchCards(
    String keyword,
    int limit,
  );
  Future<Either<Failure, bool>> addCardToUser(String cardId);
  Future<Either<Failure, bool>> isCardExistInUser(String cardId);
  Future<Either<Failure, bool>> editUserCard(
    String cardId,
    int? firstPaymentDate,
    DateTime? expiryDate,
  );
}
