import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_deal_detail.dart';

abstract class MerchantAgencyRepository {
  Future<Either<Failure, List<MerchantAgency>>> getNearestMerchantAgencies({
    required int limit,
    required double latitude,
    required double longitude,
  });
  Future<Either<Failure, MerchantDetailWithCardDeals>> getMerchantAgencyDetail({
    required String agencyId,
  });

  Future<Either<Failure, bool>> isMerchantFavorite({required String agencyId});
  Future<Either<Failure, bool>> isMerchantSubscribed({
    required String agencyId,
  });
  Future<Either<Failure, void>> toggleFavoriteMerchant({
    required String agencyId,
  });
  Future<Either<Failure, void>> toggleSubscribeMerchant({
    required String agencyId,
  });

  Future<Either<Failure, List<MerchantAgency>>> searchMerchantAgencies({
    required String keyword,
    double latitude = 0,
    double longitude = 0,
    int limit = 10,
    String sort = 'NAME_ASC',
  });

  Future<Either<Failure, List<MerchantDealDetail>>> getMerchantDealDetail({
    required String agencyId,
  });
}
