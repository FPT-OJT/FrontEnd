import 'package:fpt_ojt/features/location/data/models/geofence_dto.dart';
import 'package:fpt_ojt/features/location/domain/entities/geofence.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

abstract class GeofenceDatasource {
  Future<void> register(List<AgencyGeofence> agencies);
  Future<void> unregisterAll();
  Future<void> update(List<AgencyGeofence> agencies);
  Future<ApiResponse<List<GeofenceDto>>> getGeofences();
}
