import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/merchant_agency_repository.dart';

class SearchMerchantAgenciesUseCase
    implements UseCase<List<MerchantAgency>, SearchMerchantAgenciesParams> {
  SearchMerchantAgenciesUseCase({required this.merchantAgencyRepository});

  final MerchantAgencyRepository merchantAgencyRepository;

  @override
  Future<Either<Failure, List<MerchantAgency>>> call(
    SearchMerchantAgenciesParams params,
  ) => merchantAgencyRepository.searchMerchantAgencies(
    keyword: params.keyword,
    latitude: params.latitude,
    longitude: params.longitude,
    limit: params.limit,
    sort: params.sort,
  );
}

@immutable
class SearchMerchantAgenciesParams extends Equatable {
  const SearchMerchantAgenciesParams({
    required this.keyword,
    this.latitude = 0,
    this.longitude = 0,
    this.limit = 10,
    this.sort = 'NAME_ASC',
  });

  final String keyword;
  final double latitude;
  final double longitude;
  final int limit;
  final String sort;

  @override
  List<Object?> get props => [keyword, latitude, longitude, limit, sort];
}
