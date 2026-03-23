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
}
