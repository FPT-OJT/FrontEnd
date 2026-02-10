import 'package:fpt_ojt/features/profile/domain/entities/country.dart';
import 'package:fpt_ojt/features/profile/domain/entities/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_profile_state.freezed.dart';

enum UpdateProfileStatus { initial, loading, loaded, success, failure }

@freezed
abstract class UpdateProfileState with _$UpdateProfileState {
  const factory UpdateProfileState({
    @Default(UpdateProfileStatus.initial) UpdateProfileStatus status,
    @Default([]) List<Country> countries,
    Profile? profile,
    String? errorMessage,
  }) = _UpdateProfileState;
}
