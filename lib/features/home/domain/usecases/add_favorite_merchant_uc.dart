import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/home/domain/repositories/home_repository.dart';

class AddFavoriteMerchantUc
    implements UseCase<void, AddFavoriteMerchantParams> {
  AddFavoriteMerchantUc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository;
  final HomeRepository _homeRepository;

  @override
  Future<Either<Failure, void>> call(AddFavoriteMerchantParams params) async =>
      _homeRepository.addFavoriteMerchant(params.merchantAgencyId);
}

class AddFavoriteMerchantParams extends Equatable {
  const AddFavoriteMerchantParams({required this.merchantAgencyId});
  final String merchantAgencyId;

  @override
  List<Object?> get props => [merchantAgencyId];
}
