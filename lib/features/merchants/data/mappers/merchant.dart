import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/merchants/data/models/merchant_agency_model.dart';
import 'package:fpt_ojt/features/merchants/data/models/merchant_agency_search_result_model.dart';
import 'package:fpt_ojt/features/merchants/data/models/merchant_model.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';

extension MerchantMapper on MerchantModel {
  Merchant toEntity() => Merchant(
    id: id,
    name: name,
    description: description ?? '',
    logoUrl: logoUrl ?? '',
  );
}

extension MerchantAgencyMapper on MerchantAgencyModel {
  MerchantAgency toEntity() => MerchantAgency(
    id: id,
    name: name,
    imageUrl: imageUrl ?? '',
    discount: 20,
    location: Coordinate(latitude: latitude ?? 0, longitude: longitude ?? 0),
    merchant: merchant.toEntity(),
    merchantId: merchant.id,
  );
}

extension ListMerchantAgencyMapper on List<MerchantAgencyModel> {
  List<MerchantAgency> toEntities() => map((e) => e.toEntity()).toList();
}

extension MerchantAgencySearchResultMapper on MerchantAgencySearchResultModel {
  MerchantAgency toEntity() => MerchantAgency(
    id: agencyId,
    name: agencyName,
    imageUrl: logoUrl ?? '',
    discount: 0,
    location: Coordinate(latitude: latitude ?? 0, longitude: longitude ?? 0),
    distance: distanceMeters,
    merchant: Merchant(
      id: agencyId,
      name: merchantName,
      description: description ?? '',
      logoUrl: logoUrl ?? '',
    ),
    merchantId: agencyId,
  );
}

extension ListMerchantAgencySearchResultMapper
    on List<MerchantAgencySearchResultModel> {
  List<MerchantAgency> toEntities() => map((e) => e.toEntity()).toList();
}
