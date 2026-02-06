import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';
import 'package:fpt_ojt/features/wallet/data/datasources/wallet_datasource.dart';
import 'package:fpt_ojt/features/wallet/data/models/my_card.dart';
import 'package:fpt_ojt/features/wallet/data/models/my_fav_merchant.dart';

class WalletDatasourceImpl implements WalletDatasource {
  WalletDatasourceImpl({required Dio dio}) : _dio = dio;
  final Dio _dio;

  @override
  Future<ApiResponse<List<MyCard>>> getMyApps(String cardType) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/user-cards/card-type/$cardType',
    );
    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => (json! as List)
          .map((item) => MyCard.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResponse<List<MyCard>>> getMyCards() async {
    final response = await _dio.get<Map<String, dynamic>>('/user-cards/@me');
    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => (json! as List)
          .map((item) => MyCard.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResponse<List<MyFavMerchant>>> getMyFavMerchants() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/users/favorite-merchants',
    );
    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => (json! as List)
          .map((item) => MyFavMerchant.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
