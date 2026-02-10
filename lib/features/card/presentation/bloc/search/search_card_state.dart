import 'package:fpt_ojt/features/card/domain/entities/card_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'search_card_state.freezed.dart';

enum SearchCardLoadStatus { initial, loading, success, failure }

@freezed
abstract class SearchCardState with _$SearchCardState {
  const factory SearchCardState({
    @Default(SearchCardLoadStatus.initial) SearchCardLoadStatus searchStatus,
    @Default([]) List<CardEntity> cards,
    String? errorMessage,
  }) = _SearchCardState;
}
