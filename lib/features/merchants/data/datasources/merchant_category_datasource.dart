import 'package:fpt_ojt/features/merchants/data/models/merchant_category.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

abstract interface class MerchantCategoryDataSource {
  Future<ApiResponse<List<CategoryModel>>> getMerchantCategories({
    required int page,
    required int limit,
  });
}
