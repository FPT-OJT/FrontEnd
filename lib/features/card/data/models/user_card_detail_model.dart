import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_card_detail_model.freezed.dart';
part 'user_card_detail_model.g.dart';

@freezed
abstract class UserCardDetailModel with _$UserCardDetailModel {
  const factory UserCardDetailModel({
    required String userCardId,
    required String cardName,
    required String cardType,
    required String? cardImageUrl,
    required int? firstPaymentDate,
    required DateTime? expiryDate,
  }) = _UserCardDetailModel;

  factory UserCardDetailModel.fromJson(Map<String, dynamic> json) =>
      _$UserCardDetailModelFromJson(json);
}
