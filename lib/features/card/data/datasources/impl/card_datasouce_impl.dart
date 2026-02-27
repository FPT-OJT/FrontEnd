import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/card/data/datasources/card_datasource.dart';
import 'package:fpt_ojt/features/card/data/models/card_model.dart';
import 'package:fpt_ojt/features/card/data/models/user_card_detail_model.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

class CardDatasouceImpl implements CardDatasource {
  CardDatasouceImpl({required Dio dio}) : _dio = dio;
  final Dio _dio;

  @override
  Future<ApiResponse<List<CardModel>>> searchCards(
    String keyword,
    int limit,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/core/cards/search',
      queryParameters: {'keyword': keyword, 'limit': limit},
    );

    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => (json! as List<dynamic>)
          .map((item) => CardModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResponse<String>> addCardToUser(String cardId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/core/user-cards',
      data: {'cardId': cardId},
    );

    return ApiResponse.fromJson(response.data ?? {}, (json) => json! as String);
  }

  @override
  Future<ApiResponse<bool>> isCardExistInUser(String cardId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/core/user-cards/is-exists/$cardId',
    );

    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => json == 'ok' || json == true || json is bool && json,
    );
  }

  @override
  Future<ApiResponse<bool>> editUserCard(
    String cardId,
    int? firstPaymentDate,
    DateTime? expiryDate,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/api/core/user-cards/$cardId',
      data: {
        if (firstPaymentDate != null) 'firstPaymentDate': firstPaymentDate,
        if (expiryDate != null)
          'expiryDate': expiryDate.toIso8601String().split('T')[0],
      },
    );

    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => json == 'ok' || json == true,
    );
  }

  @override
  Future<ApiResponse<UserCardDetailModel>> getUserCardDetail(
    String userCardId,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/core/user-cards/$userCardId',
    );

    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => UserCardDetailModel.fromJson(json! as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<bool>> deleteUserCard(String userCardId) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '/api/core/user-cards/$userCardId',
    );

    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => json == 'ok' || json == true,
    );
  }
}
