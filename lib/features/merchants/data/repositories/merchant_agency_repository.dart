import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/location/data/datasource/location_datasource.dart';
import 'package:fpt_ojt/features/merchants/data/datasources/merchant_agency_datasource.dart';
import 'package:fpt_ojt/features/merchants/data/mappers/merchant.dart';
import 'package:fpt_ojt/features/merchants/data/mappers/merchant_detail.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_deal_detail.dart';
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

  @override
  Future<Either<Failure, MerchantDetailWithCardDeals>> getMerchantAgencyDetail({
    required String agencyId,
  }) async {
    try {
      final response = await merchantAgencyDataSource.getMerchantAgencyDetail(
        agencyId: agencyId,
      );
      return Right(response.data!.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isMerchantFavorite({
    required String agencyId,
  }) async {
    try {
      final result = await merchantAgencyDataSource.isMerchantFavorite(
        agencyId: agencyId,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isMerchantSubscribed({
    required String agencyId,
  }) async {
    try {
      final result = await merchantAgencyDataSource.isMerchantSubscribed(
        agencyId: agencyId,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavoriteMerchant({
    required String agencyId,
  }) async {
    try {
      await merchantAgencyDataSource.toggleFavoriteMerchant(agencyId: agencyId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> toggleSubscribeMerchant({
    required String agencyId,
  }) async {
    try {
      await merchantAgencyDataSource.toggleSubscribeMerchant(
        agencyId: agencyId,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<MerchantAgency>>> searchMerchantAgencies({
    required String keyword,
    double latitude = 0,
    double longitude = 0,
    int limit = 10,
    String sort = 'NAME_ASC',
  }) async {
    try {
      final models = await merchantAgencyDataSource.searchMerchantAgencies(
        keyword: keyword,
        latitude: latitude,
        longitude: longitude,
        limit: limit,
        sort: sort,
      );
      return Right(models.toEntities());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
