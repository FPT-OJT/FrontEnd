import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_card.freezed.dart';
part 'my_card.g.dart';

@Freezed()
abstract class MyCard with _$MyCard {
  const factory MyCard({String? userCardId, String? cardImageUrl}) = _MyCard;

  factory MyCard.fromJson(Map<String, dynamic> json) => _$MyCardFromJson(json);
}
