import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_deal_detail.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/merchant_agency_repository.dart';

class GetMerchantDealUseCase implements UseCase<List<MerchantDealDetail>, String> {
  GetMerchantDealUseCase({
    required this.merchantAgencyRepository,
  });
  final MerchantAgencyRepository merchantAgencyRepository;

  @override
  Future<Either<Failure, List<MerchantDealDetail>>> call(String agencyId) async => merchantAgencyRepository.getMerchantDealDetail(agencyId: agencyId);
}