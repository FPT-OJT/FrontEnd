import 'package:flutter/foundation.dart';
import 'package:fpt_ojt/features/location/blocs/geofence/geofence_bloc.dart';
import 'package:fpt_ojt/features/location/blocs/geofence/geofence_event.dart';
import 'package:geofence_service/geofence_service.dart';

class GeofenceObserver {
  GeofenceObserver(this._geofenceService, this._bloc);
  bool isRunning = false;
  final GeofenceService _geofenceService;
  final GeofenceBloc _bloc;

  void start() {
    if (isRunning) return;
    debugPrint('start geofence observer');
    isRunning = true;
    _geofenceService.addGeofenceStatusChangeListener((
      geofence,
      geofenceRadius,
      geofenceStatus,
      location,
    ) async {
      debugPrint('on geofence status change: $geofenceStatus');
      if (geofenceStatus == GeofenceStatus.ENTER) {
        _bloc.add(GeofenceEvent.entered(agencyId: geofence.id));
      }

      if (geofenceStatus == GeofenceStatus.EXIT) {
        _bloc.add(GeofenceEvent.exited(agencyId: geofence.id));
      }
    });
    _geofenceService.addLocationChangeListener((location) {
      debugPrint(
        'GEOFENCE SERVICE LOCATION: '
        '${location.latitude}, ${location.longitude}',
      );
    });
  }

  void dispose() {
    _geofenceService.clearAllListeners();
    isRunning = false;
  }
}
