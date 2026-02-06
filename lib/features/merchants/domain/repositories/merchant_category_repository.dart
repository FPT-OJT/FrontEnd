import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_category.dart';

abstract class MerchantCategoryRepository {
  Future<Either<Failure, List<MerchantCategory>>> getMerchantCategories({
    required int page,
    required int limit,
  });
}
