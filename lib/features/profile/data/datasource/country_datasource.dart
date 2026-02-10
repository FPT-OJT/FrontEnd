import 'package:fpt_ojt/features/profile/data/models/country_model.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

abstract interface class CountryDatasource {
  Future<ApiResponse<List<CountryModel>>> getCountries();
}
