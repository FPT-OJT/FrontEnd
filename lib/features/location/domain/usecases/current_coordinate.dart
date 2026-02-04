import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/location/domain/repositories/location_repository.dart';

class CurrentCoordinateUseCase implements UseCase<Coordinate, NoParams> {
  CurrentCoordinateUseCase({required LocationRepository locationRepository})
    : _locationRepository = locationRepository;
  final LocationRepository _locationRepository;
  @override
  Future<Either<Failure, Coordinate>> call(NoParams params) async =>
      _locationRepository.getCurrentCoordinate();
}
