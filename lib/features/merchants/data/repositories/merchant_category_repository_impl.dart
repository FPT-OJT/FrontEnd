import 'package:fpdart/src/either.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/merchants/data/datasources/merchant_category_datasource.dart';
import 'package:fpt_ojt/features/merchants/data/mappers/merchant_category_mapper.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_category.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/merchant_category_repository.dart';

class MerchantCategoryRepositoryImpl implements MerchantCategoryRepository {
  MerchantCategoryRepositoryImpl({required this.dataSource});
  final MerchantCategoryDataSource dataSource;
  @override
  Future<Either<Failure, List<MerchantCategory>>> getMerchantCategories({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await dataSource.getMerchantCategories(
        page: page,
        limit: limit,
      );
      return Right(response.data!.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
