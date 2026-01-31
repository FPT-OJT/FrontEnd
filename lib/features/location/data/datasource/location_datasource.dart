import 'package:geolocator/geolocator.dart';

abstract class LocationDataSource {
  Future<Position> getCurrentCoordinate();
  Stream<Position> getCurrentPositionStream({
    required Duration timeLimit,
    required LocationAccuracy accuracy,
    required int distanceFilterInMeters,
  });
}
