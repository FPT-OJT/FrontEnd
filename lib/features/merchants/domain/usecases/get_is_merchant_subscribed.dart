import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/merchant_agency_repository.dart';

class GetIsMerchantSubscribedUseCase implements UseCase<bool, String> {
  GetIsMerchantSubscribedUseCase({required this.merchantAgencyRepository});

  final MerchantAgencyRepository merchantAgencyRepository;

  @override
  Future<Either<Failure, bool>> call(String agencyId) =>
      merchantAgencyRepository.isMerchantSubscribed(agencyId: agencyId);
}
