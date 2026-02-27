import 'package:fpt_ojt/features/merchants/data/models/merchant_deal_model.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_deal_detail.dart';

extension MerchantDealMapper on MerchantDealModel {
  MerchantDealDetail toEntity() => MerchantDealDetail(
    id: id,
    merchantName: merchantName,
    logoUrl: logoUrl,
    merchantDescription: merchantDescription,
    agencyName: agencyName,
    dealName: dealName,
    discountRate: discountRate,
    cashbackRate: cashbackRate,
    pointsMultiplier: pointsMultiplier,
    description: description,
    agencyId: agencyId,
  );
}
extension ListMerchantDealMapper on List<MerchantDealModel> {
  List<MerchantDealDetail> toEntities() => map((e) => e.toEntity()).toList();
}