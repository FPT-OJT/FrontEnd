import 'package:fpt_ojt/features/merchants/data/models/merchant_agency_cards_deals_response.dart';
import 'package:fpt_ojt/features/merchants/data/models/merchant_agency_model.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

abstract class MerchantAgencyDatasource {
  Future<List<MerchantAgencyModel>> getNearestMerchants({
    required double latitude,
    required double longitude,
    required int limit,
  });
  Future<ApiResponse<MerchantAgencyCardsDealsResponse>> getMerchantAgencyDetail({
    required String agencyId,
  });
}
