import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/merchant_agency_repository.dart';

class GetNearestMerchantAgenciesUseCase
    implements UseCase<List<MerchantAgency>, GetNearestMerchantAgenciesParams> {
  GetNearestMerchantAgenciesUseCase(this.merchantAgencyRepository);
  final MerchantAgencyRepository merchantAgencyRepository;

  @override
  Future<Either<Failure, List<MerchantAgency>>> call(
    GetNearestMerchantAgenciesParams params,
  ) => merchantAgencyRepository.getNearestMerchantAgencies(
    limit: params.limit,
    latitude: params.latitude,
    longitude: params.longitude,
  );
}

@immutable
class GetNearestMerchantAgenciesParams extends Equatable {
  const GetNearestMerchantAgenciesParams({
    required this.limit,
    required this.latitude,
    required this.longitude,
  });
  final int limit;
  final double latitude;
  final double longitude;
  @override
  List<Object?> get props => [limit, latitude, longitude];
}
