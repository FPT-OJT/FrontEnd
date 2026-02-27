import 'package:fpt_ojt/features/location/data/models/geofence_dto.dart';
import 'package:fpt_ojt/features/location/domain/entities/geofence.dart';
import 'package:geofence_service/geofence_service.dart';

extension AgencyGeofenceMapper on AgencyGeofence {
  Geofence toGeofence() => Geofence(
    id: id,
    latitude: latitude,
    longitude: longitude,
    radius: [GeofenceRadius(id: '${id}_radius', length: 370)],
  );
}

extension GeofenceDtoMapper on GeofenceDto {
  AgencyGeofence toDomain() => AgencyGeofence(
    id: id,
    latitude: latitude,
    longitude: longitude,
    radius: metersRadius,
  );
}
