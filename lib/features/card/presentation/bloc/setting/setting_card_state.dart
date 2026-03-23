import 'package:fpt_ojt/features/card/domain/entities/user_card_detail_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'setting_card_state.freezed.dart';

enum SettingCardStateStatus {
  initial,
  loading,
  success,
  failure,
  updating,
  updated,
  deleting,
  deleted,
}

@freezed
abstract class SettingCardState with _$SettingCardState {
  const factory SettingCardState({
    @Default(SettingCardStateStatus.initial)
    SettingCardStateStatus settingStatus,
    @Default(null) UserCardDetailEntity? cardDetail,
    @Default(false) bool isDataChanged,
    String? warningMessage,
    String? errorMessage,
  }) = _SettingCardState;
}
