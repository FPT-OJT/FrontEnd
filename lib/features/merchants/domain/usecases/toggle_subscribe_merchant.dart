import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/merchant_agency_repository.dart';

class ToggleSubscribeMerchantUseCase implements UseCase<void, String> {
  ToggleSubscribeMerchantUseCase({required this.merchantAgencyRepository});

  final MerchantAgencyRepository merchantAgencyRepository;

  @override
  Future<Either<Failure, void>> call(String agencyId) =>
      merchantAgencyRepository.toggleSubscribeMerchant(agencyId: agencyId);
}
