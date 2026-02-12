import 'package:fpt_ojt/features/home/data/models/home_data.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

abstract interface class HomeDatasource {
  Future<ApiResponse<HomeData>> getHome();
  Future<ApiResponse<void>> subscribeToMerchant(String merchantAgencyId);
  Future<ApiResponse<void>> addFavoriteMerchant(String merchantAgencyId);
}
