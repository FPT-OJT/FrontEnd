import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/home/domain/repositories/home_repository.dart';

class SubscribeToMerchantUc
    implements UseCase<void, SubscribeToMerchantParams> {
  SubscribeToMerchantUc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository;
  final HomeRepository _homeRepository;

  @override
  Future<Either<Failure, void>> call(SubscribeToMerchantParams params) async =>
      _homeRepository.subscribeToMerchant(params.merchantAgencyId);
}

class SubscribeToMerchantParams extends Equatable {
  const SubscribeToMerchantParams({required this.merchantAgencyId});
  final String merchantAgencyId;

  @override
  List<Object?> get props => [merchantAgencyId];
}
