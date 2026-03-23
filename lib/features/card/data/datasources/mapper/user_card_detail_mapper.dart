import 'package:fpt_ojt/features/card/data/models/user_card_detail_model.dart';
import 'package:fpt_ojt/features/card/domain/entities/user_card_detail_entity.dart';

extension UserCardDetailModelMapper on UserCardDetailModel {
  UserCardDetailEntity toEntity() => UserCardDetailEntity(
    userCardId: userCardId,
    cardName: cardName,
    cardType: cardType,
    cardImageUrl: cardImageUrl,
    firstPaymentDate: firstPaymentDate,
    expiryDate: expiryDate,
  );
}
