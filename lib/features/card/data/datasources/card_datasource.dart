import 'package:fpt_ojt/features/card/data/models/card_model.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

abstract interface class CardDatasource {
  Future<ApiResponse<List<CardModel>>> searchCards(String keyWord, int limit);
  Future<ApiResponse<bool>> addCardToUser(String cardId);
  Future<ApiResponse<bool>> isCardExistInUser(String cardId);
}
