import 'package:fpt_ojt/features/card/domain/entities/card_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'detail_card_sheet_state.freezed.dart';

enum DetailCardLoadStatus { initial, loading, success, failure }

@freezed
abstract class DetailCardSheetState with _$DetailCardSheetState {
  const factory DetailCardSheetState({
    @Default(DetailCardLoadStatus.initial) DetailCardLoadStatus detailStatus,
    @Default(null) CardEntity? selectedCard,
    String? userCardId,
    String? errorMessage,
  }) = _DetailCardSheetState;
}
