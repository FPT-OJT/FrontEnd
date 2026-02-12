import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/profile/data/datasource/country_datasource.dart';
import 'package:fpt_ojt/features/profile/data/models/country_model.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

class CountryDatasourceImpl implements CountryDatasource {
  CountryDatasourceImpl({required Dio dio}) : _dio = dio;
  final Dio _dio;

  @override
  Future<ApiResponse<List<CountryModel>>> getCountries() async {
    final response = await _dio.get<Map<String, dynamic>>('/countries');
    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => (json! as List)
          .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
