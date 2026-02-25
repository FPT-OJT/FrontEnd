import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/recent_search_repository.dart';

class GetRecentSearchesUseCase
    implements UseCase<List<MerchantAgency>, NoParams> {
  GetRecentSearchesUseCase({required this.recentSearchRepository});

  final RecentSearchRepository recentSearchRepository;

  @override
  Future<Either<Failure, List<MerchantAgency>>> call(NoParams params) =>
      recentSearchRepository.getRecentSearches();
}
