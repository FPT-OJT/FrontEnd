import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/location/data/datasource/location_datasource.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/location/domain/repositories/location_repository.dart';
import 'package:geolocator/geolocator.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl({required LocationDataSource locationDataSource})
    : _locationDataSource = locationDataSource;
  Stream<Coordinate>? _positionStream;
  final LocationDataSource _locationDataSource;
  @override
  Future<Either<Failure, Coordinate>> getCurrentCoordinate() async {
    final position = await _locationDataSource.getCurrentCoordinate();
    return Right(
      Coordinate(latitude: position.latitude, longitude: position.longitude),
    );
  }

  @override
  Stream<Coordinate> getCurrentPositionStream({
    required Duration timeLimit,
    required int distanceFilterInMeters,
  }) {
    if (_positionStream != null) return _positionStream!;

    _positionStream = _locationDataSource
        .getCurrentPositionStream(
          timeLimit: timeLimit,
          accuracy: LocationAccuracy.lowest,
          distanceFilterInMeters: distanceFilterInMeters,
        )
        .map((p) => Coordinate(latitude: p.latitude, longitude: p.longitude))
        .asBroadcastStream();

    return _positionStream!;
  }

  @override
  Future<Either<Failure, double>> getDistanceBetweenCoordinates(
    Coordinate from,
    Coordinate to,
  ) async {
    try {
      final response = await _locationDataSource.getDistanceBetweenCoordinates(
        from,
        to,
      );

      // shortest distance (meters)
      final distance = response.routes.first.distance;

      return Right(distance);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
