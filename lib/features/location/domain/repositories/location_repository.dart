import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';

abstract interface class LocationRepository {
  Future<Either<Failure, Coordinate>> getCurrentCoordinate();
  Stream<Coordinate> getCurrentPositionStream({
    required Duration timeLimit,
    required int distanceFilterInMeters,
  });
}
