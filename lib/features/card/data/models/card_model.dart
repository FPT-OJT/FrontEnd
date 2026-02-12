import 'package:fpt_ojt/features/card/domain/entities/card_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_model.freezed.dart';
part 'card_model.g.dart';

@freezed
abstract class CardModel with _$CardModel {
  const factory CardModel({
    required String id,
    required String cardName,
    required String cardType,
    required String imageUrl,
  }) = _CardModel;

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);
}

extension CardModelMapper on CardModel {
  CardEntity toEntity() =>
      CardEntity(id: id, name: cardName, imageUrl: imageUrl);
}
