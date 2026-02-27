import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/merchants/data/datasources/impl/mock.dart';
import 'package:fpt_ojt/features/merchants/data/datasources/merchant_agency_datasource.dart';
import 'package:fpt_ojt/features/merchants/data/models/merchant_agency_cards_deals_response.dart';
import 'package:fpt_ojt/features/merchants/data/models/merchant_agency_model.dart';
import 'package:fpt_ojt/features/merchants/data/models/merchant_agency_search_result_model.dart';
import 'package:fpt_ojt/features/merchants/data/models/merchant_deal_model.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

class MerchantAgencyDatasourceImpl implements MerchantAgencyDatasource {
  MerchantAgencyDatasourceImpl({required Dio dio}) : _dio = dio;

  // ignore: unused_field
  final Dio _dio;

  @override
  Future<List<MerchantAgencyModel>> getNearestMerchants({
    required double latitude,
    required double longitude,
    required int limit,
  }) async {
    final json = jsonDecode(mockMerchantAgencies) as List<dynamic>;
    return json
        .map((e) => MerchantAgencyModel.fromJson(e as Map<String, dynamic>))
        .take(limit)
        .toList();
  }

  @override
  Future<ApiResponse<MerchantAgencyCardsDealsResponse>>
  getMerchantAgencyDetail({required String agencyId}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/core/merchants/agencies/$agencyId/cards-deals',
    );
    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => MerchantAgencyCardsDealsResponse.fromJson(
        json! as Map<String, dynamic>,
      ),
    );
  }

  @override
  Future<List<MerchantAgencySearchResultModel>> searchMerchantAgencies({
    required String keyword,
    double latitude = 0,
    double longitude = 0,
    int limit = 10,
    String sort = 'NAME_ASC',
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/core/merchants/agencies/nearest',
      queryParameters: {
        'keyword': keyword,
        'latitude': latitude,
        'longitude': longitude,
        'limit': limit,
        'sort': sort,
      },
    );
    final apiResponse = ApiResponse.fromJson(
      response.data ?? {},
      (json) => (json! as List<dynamic>)
          .map(
            (e) => MerchantAgencySearchResultModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
    return apiResponse.data ?? [];
  }

  @override
  Future<bool> isMerchantFavorite({required String agencyId}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/core/users/favorite-merchants/agencies/$agencyId/is-favorite',
    );
    final apiResponse = ApiResponse.fromJson(
      response.data ?? {},
      (json) => json! as bool,
    );
    return apiResponse.data ?? false;
  }

  @override
  Future<bool> isMerchantSubscribed({required String agencyId}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/core/users/subscribed-merchants/agencies/$agencyId/is-subscribed',
    );
    final apiResponse = ApiResponse.fromJson(
      response.data ?? {},
      (json) => json! as bool,
    );
    return apiResponse.data ?? false;
  }

  @override
  Future<void> toggleFavoriteMerchant({required String agencyId}) async {
    await _dio.post<Map<String, dynamic>>(
      '/api/core/users/favorite-merchants',
      data: {'merchantAgencyId': agencyId},
    );
  }

  @override
  Future<void> toggleSubscribeMerchant({required String agencyId}) async {
    await _dio.post<Map<String, dynamic>>(
      '/api/core/users/subscribed-merchants/agencies/$agencyId',
    );
  }

  @override
  Future<List<MerchantDealModel>> getMerchantDealDetail({
    required String agencyId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/core/merchants/agencies/$agencyId/deals',
    );
    final apiResponse = ApiResponse.fromJson(
      response.data ?? {},
      (json) => (json! as List<dynamic>)
          .map(
            (e) => MerchantDealModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
    return apiResponse.data ?? [];
  }
}
