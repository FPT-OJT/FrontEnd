import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/home/data/models/home_data.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, HomeData>> getHomeData({
    double? lat = 0,
    double? long = 0,
  });
  Future<Either<Failure, void>> subscribeToMerchant(String merchantAgencyId);
  Future<Either<Failure, void>> addFavoriteMerchant(String merchantAgencyId);
}
