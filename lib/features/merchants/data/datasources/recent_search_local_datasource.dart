import 'package:fpt_ojt/features/merchants/data/models/merchant_agency_model.dart';

abstract class RecentSearchLocalDatasource {
  Future<List<MerchantAgencyModel>> getRecentSearches();
  Future<void> pushRecentSearch(MerchantAgencyModel agency);
}
