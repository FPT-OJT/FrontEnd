import 'package:fpt_ojt/features/merchants/data/models/merchant_agency_model.dart';

abstract class MerchantAgencyDatasource {
  Future<List<MerchantAgencyModel>> getNearestMerchants({
    required double latitude,
    required double longitude,
    required int limit,
  });
}
