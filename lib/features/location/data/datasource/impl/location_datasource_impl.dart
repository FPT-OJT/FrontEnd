import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/location/data/datasource/location_datasource.dart';
import 'package:fpt_ojt/features/location/data/models/osrm_route_response.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:geolocator/geolocator.dart';

class LocationDatasourceImpl extends LocationDataSource {
  LocationDatasourceImpl({required this.dio});
  final Dio dio;
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

  @override
  Future<OsrmRouteResponse> getDistanceBetweenCoordinates(
    Coordinate from,
    Coordinate to,
  ) async {
    const osrmUrl = String.fromEnvironment('OSRM_URL');

    final response = await dio.get<Map<String, dynamic>>(
      '$osrmUrl/driving/'
      '${from.longitude},${from.latitude};${to.longitude},${to.latitude}',
      queryParameters: {'geometries': 'geojson'},
    );

    return OsrmRouteResponse.fromJson(response.data ?? {});
  }
}
