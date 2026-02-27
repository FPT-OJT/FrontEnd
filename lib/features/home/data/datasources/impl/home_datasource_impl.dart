import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/home/data/datasources/home_datasource.dart';
import 'package:fpt_ojt/features/home/data/models/home_data.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

class HomeDatasourceImpl implements HomeDatasource {
  HomeDatasourceImpl({required Dio dio}) : _dio = dio;
  final Dio _dio;

  @override
  Future<ApiResponse<HomeData>> getHome({
    double? lat = 0,
    double? long = 0,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/core/home',
      queryParameters: {'lat': lat, 'long': long},
    );

    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => HomeData.fromJson(json! as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> subscribeToMerchant(String merchantAgencyId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/core/users/subscribed-merchants/agencies/$merchantAgencyId',
    );

    return ApiResponse.fromJson(response.data ?? {}, (json) {});
  }

  @override
  Future<ApiResponse<void>> addFavoriteMerchant(String merchantAgencyId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/core/users/favorite-merchants',
      data: {'merchantAgencyId': merchantAgencyId},
    );

    return ApiResponse.fromJson(response.data ?? {}, (json) {});
  }
}
