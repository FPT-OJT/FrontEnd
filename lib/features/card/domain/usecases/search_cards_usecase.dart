import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/card/domain/entities/card_entity.dart';
import 'package:fpt_ojt/features/card/domain/repositories/card_repositories.dart';

class SearchCardsUsecase
    implements UseCase<List<CardEntity>, SearchCardsParams> {
  SearchCardsUsecase({required CardRepositories cardRepositories})
    : _cardRepositories = cardRepositories;
  final CardRepositories _cardRepositories;

  @override
  Future<Either<Failure, List<CardEntity>>> call(
    SearchCardsParams params,
  ) async => _cardRepositories.searchCards(params.keyword, params.limit);
}

class SearchCardsParams extends Equatable {
  const SearchCardsParams({required this.keyword, required this.limit});

  final String keyword;
  final int limit;

  @override
  List<Object?> get props => [keyword, limit];
}
