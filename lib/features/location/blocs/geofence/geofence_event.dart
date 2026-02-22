import 'package:freezed_annotation/freezed_annotation.dart';
part 'geofence_event.freezed.dart';

@freezed
sealed class GeofenceEvent with _$GeofenceEvent {
  const factory GeofenceEvent.started() = GeofenceStarted;
  const factory GeofenceEvent.entered({
    required String agencyId,
  }) = GeofenceEntered;

  const factory GeofenceEvent.exited({
    required String agencyId,
  }) = GeofenceExited;
}
