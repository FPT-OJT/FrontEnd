import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/card/data/datasources/card_datasource.dart';
import 'package:fpt_ojt/features/card/data/models/card_model.dart';
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
      '/cards/search',
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
  Future<ApiResponse<bool>> addCardToUser(String cardId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/user-cards',
      data: {'cardId': cardId},
    );

    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => json == 'ok' || json == true,
    );
  }

  @override
  Future<ApiResponse<bool>> isCardExistInUser(String cardId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/user-cards/is-exists/$cardId',
    );

    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => json == 'ok' || json == true || json is bool && json,
    );
  }
}
