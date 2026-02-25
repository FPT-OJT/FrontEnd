import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';

abstract class RecentSearchRepository {
  Future<Either<Failure, List<MerchantAgency>>> getRecentSearches();
  Future<Either<Failure, void>> pushRecentSearch(MerchantAgency agency);
}
