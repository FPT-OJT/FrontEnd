import 'package:fpt_ojt/features/card/domain/entities/card_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'detail_card_state.freezed.dart';

enum DetailCardLoadStatus { initial, loading, success, failure }

@freezed
abstract class DetailCardState with _$DetailCardState {
  const factory DetailCardState({
    @Default(DetailCardLoadStatus.initial) DetailCardLoadStatus detailStatus,
    @Default(null) CardEntity? selectedCard,
    @Default(false) bool isCurrentCardInUser,
    String? errorMessage,
  }) = _DetailCardState;
}
