import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_category.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/merchant_category_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class GetMerchantCategoriesUseCase
    implements UseCase<List<MerchantCategory>, GetMerchantCategoriesParams> {
  GetMerchantCategoriesUseCase({
    required MerchantCategoryRepository merchantCategoryRepository,
  }) : _merchantCategoryRepository = merchantCategoryRepository;
  final MerchantCategoryRepository _merchantCategoryRepository;
  @override
  Future<Either<Failure, List<MerchantCategory>>> call(
    GetMerchantCategoriesParams params,
  ) async => _merchantCategoryRepository.getMerchantCategories(
    page: params.page,
    limit: params.limit,
  );
}

@immutable
class GetMerchantCategoriesParams extends Equatable {
  const GetMerchantCategoriesParams({required this.page, required this.limit});
  final int page;
  final int limit;
  @override
  List<Object?> get props => [page, limit];
}
