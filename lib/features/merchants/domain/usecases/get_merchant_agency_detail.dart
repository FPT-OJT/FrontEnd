import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_deal_detail.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/merchant_agency_repository.dart';

class GetMerchantAgencyDetailUseCase
    implements UseCase<MerchantDetailWithCardDeals, String> {
  GetMerchantAgencyDetailUseCase({
    required MerchantAgencyRepository merchantAgencyRepository,
  }) : _merchantAgencyRepository = merchantAgencyRepository;
  final MerchantAgencyRepository _merchantAgencyRepository;
  @override
  Future<Either<Failure, MerchantDetailWithCardDeals>> call(String params) => _merchantAgencyRepository.getMerchantAgencyDetail(agencyId: params);
}
