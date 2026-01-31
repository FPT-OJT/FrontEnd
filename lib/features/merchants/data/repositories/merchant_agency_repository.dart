import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/location/data/datasource/location_datasource.dart';
import 'package:fpt_ojt/features/merchants/data/datasources/merchant_agency_datasource.dart';
import 'package:fpt_ojt/features/merchants/data/mappers/merchant.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/merchant_agency_repository.dart';

class MerchantAgencyRepositoryImpl implements MerchantAgencyRepository {
  MerchantAgencyRepositoryImpl({
    required this.merchantAgencyDataSource,
    required this.locationDataSource,
  });
  final MerchantAgencyDatasource merchantAgencyDataSource;
  final LocationDataSource locationDataSource;
  @override
  Future<Either<Failure, List<MerchantAgency>>> getNearestMerchantAgencies({
    required int limit,
    required double latitude,
    required double longitude,
  }) async {
    final merchantAgencies = await merchantAgencyDataSource.getNearestMerchants(
      latitude: latitude,
      longitude: longitude,
      limit: limit,
    );
    return Right(merchantAgencies.toEntities());
  }
}
