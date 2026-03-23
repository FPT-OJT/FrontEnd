import 'package:fpt_ojt/features/shared/models/api_response.dart';
import 'package:fpt_ojt/features/wallet/data/models/my_card.dart';
import 'package:fpt_ojt/features/wallet/data/models/my_fav_merchant.dart';

abstract interface class WalletDatasource {
  Future<ApiResponse<List<MyCard>>> getMyCards();
  Future<ApiResponse<List<MyFavMerchant>>> getMyFavMerchants();
  Future<ApiResponse<List<MyCard>>> getMyApps(String cardType);
}
