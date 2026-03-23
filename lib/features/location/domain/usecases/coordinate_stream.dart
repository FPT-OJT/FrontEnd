import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/location/domain/repositories/location_repository.dart';

class CoordinateStreamUseCase
    implements UseCase<Stream<Coordinate>, CoordinateStreamParams> {
  CoordinateStreamUseCase({required LocationRepository locationRepository})
    : _locationRepository = locationRepository;
  final LocationRepository _locationRepository;
  @override
  Future<Either<Failure, Stream<Coordinate>>> call(
    CoordinateStreamParams params,
  ) async {
    final stream = _locationRepository.getCurrentPositionStream(
      timeLimit: params.timeLimit,
      distanceFilterInMeters: params.distanceFilterInMeters,
    );
    return Right(stream);
  }
}

class CoordinateStreamParams extends Equatable {
  const CoordinateStreamParams({
    required this.timeLimit,
    required this.distanceFilterInMeters,
  });
  final Duration timeLimit;
  final int distanceFilterInMeters;
  @override
  List<Object?> get props => [timeLimit, distanceFilterInMeters];
}
