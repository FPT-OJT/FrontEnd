import 'package:fpt_ojt/features/card/data/models/card_model.dart';
import 'package:fpt_ojt/features/card/data/models/user_card_detail_model.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

abstract interface class CardDatasource {
  Future<ApiResponse<List<CardModel>>> searchCards(String keyWord, int limit);
  Future<ApiResponse<String>> addCardToUser(String cardId);
  Future<ApiResponse<bool>> isCardExistInUser(String cardId);
  Future<ApiResponse<bool>> editUserCard(
    String cardId,
    int? firstPaymentDate,
    DateTime? expiryDate,
  );
  Future<ApiResponse<UserCardDetailModel>> getUserCardDetail(String userCardId);
  Future<ApiResponse<bool>> deleteUserCard(String userCardId);
}
