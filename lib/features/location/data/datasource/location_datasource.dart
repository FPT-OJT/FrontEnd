import 'package:fpt_ojt/features/location/data/models/osrm_route_response.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationDataSource {
  Future<Position> getCurrentCoordinate();
  Stream<Position> getCurrentPositionStream({
    required Duration timeLimit,
    required LocationAccuracy accuracy,
    required int distanceFilterInMeters,
  });
  Future<OsrmRouteResponse> getDistanceBetweenCoordinates(
    Coordinate from,
    Coordinate to,
  );
}
