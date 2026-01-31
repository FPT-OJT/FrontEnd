import 'package:fpt_ojt/features/location/data/datasource/location_datasource.dart';
import 'package:geolocator/geolocator.dart';

class LocationDatasourceImpl extends LocationDataSource {
  @override
  Future<Position> getCurrentCoordinate() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
    final position = await Geolocator.getCurrentPosition();
    return position;
  }

  @override
  Stream<Position> getCurrentPositionStream({
    required Duration timeLimit,
    required LocationAccuracy accuracy,
    required int distanceFilterInMeters,
  }) => Geolocator.getPositionStream(
    locationSettings: LocationSettings(
      timeLimit: timeLimit,
      accuracy: accuracy,
      distanceFilter: distanceFilterInMeters,
    ),
  );
}
