import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/card/domain/entities/user_card_detail_entity.dart';
import 'package:fpt_ojt/features/card/domain/repositories/card_repositories.dart';

class GetUserCardDetailUsecase
    implements UseCase<UserCardDetailEntity, GetUserCardDetailParams> {
  GetUserCardDetailUsecase({required CardRepositories cardRepositories})
    : _cardRepositories = cardRepositories;
  final CardRepositories _cardRepositories;

  @override
  Future<Either<Failure, UserCardDetailEntity>> call(
    GetUserCardDetailParams params,
  ) async => _cardRepositories.getUserCardDetail(params.userCardId);
}

class GetUserCardDetailParams extends Equatable {
  const GetUserCardDetailParams({required this.userCardId});

  final String userCardId;

  @override
  List<Object?> get props => [userCardId];
}
