import 'package:fpt_ojt/features/profile/domain/entities/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_profile_event.freezed.dart';

@freezed
class UpdateProfileEvent with _$UpdateProfileEvent {
  const factory UpdateProfileEvent.started() = UpdateProfileStarted;
  const factory UpdateProfileEvent.updateRequested({required Profile profile}) =
      UpdateProfileRequested;
}
