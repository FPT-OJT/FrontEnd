import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/merchants/data/datasources/recent_search_local_datasource.dart';
import 'package:fpt_ojt/features/merchants/data/mappers/merchant.dart';
import 'package:fpt_ojt/features/merchants/data/models/merchant_agency_model.dart';
import 'package:fpt_ojt/features/merchants/data/models/merchant_model.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/recent_search_repository.dart';

class RecentSearchRepositoryImpl implements RecentSearchRepository {
  RecentSearchRepositoryImpl({required this.recentSearchLocalDatasource});

  final RecentSearchLocalDatasource recentSearchLocalDatasource;

  @override
  Future<Either<Failure, List<MerchantAgency>>> getRecentSearches() async {
    try {
      final models = await recentSearchLocalDatasource.getRecentSearches();
      return Right(models.toEntities());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> pushRecentSearch(MerchantAgency agency) async {
    try {
      final model = MerchantAgencyModel(
        id: agency.id,
        name: agency.name,
        imageUrl: agency.imageUrl,
        latitude: agency.location.latitude,
        longitude: agency.location.longitude,
        merchant: MerchantModel(
          id: agency.merchant.id,
          name: agency.merchant.name,
          description: agency.merchant.description,
          logoUrl: agency.merchant.logoUrl,
          mcc: '',
        ),
      );
      await recentSearchLocalDatasource.pushRecentSearch(model);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
