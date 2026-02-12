import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/home/data/datasources/home_datasource.dart';
import 'package:fpt_ojt/features/home/data/models/home_data.dart';
import 'package:fpt_ojt/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required HomeDatasource homeDatasource})
    : _homeDatasource = homeDatasource;
  final HomeDatasource _homeDatasource;

  @override
  Future<Either<Failure, HomeData>> getHomeData() async {
    try {
      final apiResponse = await _homeDatasource.getHome();

      if (apiResponse.data == null) {
        return Left(Failure(apiResponse.message));
      }

      return Right(apiResponse.data!);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> subscribeToMerchant(
    String merchantAgencyId,
  ) async {
    try {
      await _homeDatasource.subscribeToMerchant(merchantAgencyId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> addFavoriteMerchant(
    String merchantAgencyId,
  ) async {
    try {
      await _homeDatasource.addFavoriteMerchant(merchantAgencyId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
