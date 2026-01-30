import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/src/either.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/merchant_agency_repository.dart';

class GetNearestMerchantAgencies
    implements UseCase<List<MerchantAgency>, GetNearestMerchantAgenciesParams> {
  GetNearestMerchantAgencies(this.merchantAgencyRepository);
  final MerchantAgencyRepository merchantAgencyRepository;

  @override
  Future<Either<Failure, List<MerchantAgency>>> call(
    GetNearestMerchantAgenciesParams params,
  ) => merchantAgencyRepository.getNearestMerchantAgencies(limit: params.limit);
}

@immutable
class GetNearestMerchantAgenciesParams extends Equatable {
  const GetNearestMerchantAgenciesParams({required this.limit});
  final int limit;

  @override
  List<Object?> get props => [limit];
}
