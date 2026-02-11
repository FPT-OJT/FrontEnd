import 'package:fpt_ojt/features/card/domain/entities/card_setting_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'setting_card_state.freezed.dart';

enum SettingCardStateStatus { initial, loading, success, failure }

@freezed
abstract class SettingCardState with _$SettingCardState {
  const factory SettingCardState({
    @Default(SettingCardStateStatus.initial)
    SettingCardStateStatus settingStatus,
    @Default(null) CardSettingEntity? card,
    String? errorMessage,
  }) = _SettingCardState;
}
