import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/location/domain/repositories/location_repository.dart';

class GetShortestDistanceUseCase
    implements UseCase<double, GetShortestDistanceParams> {
  GetShortestDistanceUseCase({required LocationRepository locationRepository})
    : _locationRepository = locationRepository;
  final LocationRepository _locationRepository;
  @override
  Future<Either<Failure, double>> call(
    GetShortestDistanceParams params,
  ) async =>
      _locationRepository.getDistanceBetweenCoordinates(params.from, params.to);
}

class GetShortestDistanceParams extends Equatable {
  const GetShortestDistanceParams({required this.from, required this.to});
  final Coordinate from;
  final Coordinate to;
  @override
  List<Object?> get props => [from, to];
}
