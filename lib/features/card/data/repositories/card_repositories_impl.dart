import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/card/data/datasources/card_datasource.dart';
import 'package:fpt_ojt/features/card/data/models/card_model.dart';
import 'package:fpt_ojt/features/card/domain/entities/card_entity.dart';
import 'package:fpt_ojt/features/card/domain/repositories/card_repositories.dart';

class CardRepositoriesImpl implements CardRepositories {
  CardRepositoriesImpl({required CardDatasource cardDatasource})
    : _cardDatasource = cardDatasource;

  final CardDatasource _cardDatasource;

  @override
  Future<Either<Failure, List<CardEntity>>> searchCards(
    String keyWord,
    int limit,
  ) async {
    try {
      final apiResponse = await _cardDatasource.searchCards(keyWord, limit);

      if (apiResponse.data == null) {
        return Left(Failure(apiResponse.message));
      }

      final entities = apiResponse.data!
          .map((model) => model.toEntity())
          .toList();
      return Right(entities);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> addCardToUser(String cardId) async {
    try {
      final apiResponse = await _cardDatasource.addCardToUser(cardId);

      if (apiResponse.data == null) {
        return Left(Failure(apiResponse.message));
      }

      return Right(apiResponse.data!);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isCardExistInUser(String cardId) async {
    try {
      final apiResponse = await _cardDatasource.isCardExistInUser(cardId);

      if (apiResponse.data == null) {
        return Left(Failure(apiResponse.message));
      }

      return Right(apiResponse.data!);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
