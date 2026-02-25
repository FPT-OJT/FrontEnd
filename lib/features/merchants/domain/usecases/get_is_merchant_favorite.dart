import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/merchant_agency_repository.dart';

class GetIsMerchantFavoriteUseCase implements UseCase<bool, String> {
  GetIsMerchantFavoriteUseCase({required this.merchantAgencyRepository});

  final MerchantAgencyRepository merchantAgencyRepository;

  @override
  Future<Either<Failure, bool>> call(String agencyId) =>
      merchantAgencyRepository.isMerchantFavorite(agencyId: agencyId);
}
