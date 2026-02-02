import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/location/data/datasource/location_datasource.dart';
import 'package:fpt_ojt/features/location/data/models/osrm_route_response.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:geolocator/geolocator.dart';

class MockMovingLocationDatasourceImpl extends LocationDataSource {
  MockMovingLocationDatasourceImpl({required this.dio});
  final Dio dio;
  final _controller = StreamController<Position>.broadcast();
  Timer? _timer;

  Position _currentPosition = Position(
    latitude: 10.771918,
    longitude: 106.699419,
    accuracy: 5,
    altitude: 10,
    heading: 90,
    speed: 1.2,
    speedAccuracy: 0.5,
    timestamp: DateTime.now(),
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );

  @override
  Future<Position> getCurrentCoordinate() async {
    // ignore: inference_failure_on_instance_creation
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentPosition;
  }

  @override
  Stream<Position> getCurrentPositionStream({
    required Duration timeLimit,
    required LocationAccuracy accuracy,
    required int distanceFilterInMeters,
  }) {
    _startFakeMoving();
    return _controller.stream;
  }

  void _startFakeMoving() {
    _timer ??= Timer.periodic(const Duration(seconds: 60), (_) {
      _currentPosition = Position(
        latitude: _currentPosition.latitude + 0.00005,
        longitude: _currentPosition.longitude + 0.00005,
        timestamp: DateTime.now(),
        accuracy: _currentPosition.accuracy,
        altitude: _currentPosition.altitude,
        altitudeAccuracy: _currentPosition.altitudeAccuracy,
        heading: _currentPosition.heading,
        headingAccuracy: _currentPosition.headingAccuracy,
        speed: _currentPosition.speed,
        speedAccuracy: _currentPosition.speedAccuracy,
      );
      _controller.add(_currentPosition);
    });
  }

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

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _controller.close();
  }
}
