import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/location/domain/entities/geofence.dart';
import 'package:fpt_ojt/features/location/domain/repositories/geofence_repository.dart';

class InitGeofenceUseCase implements UseCase<List<AgencyGeofence>, void> {
  InitGeofenceUseCase({required GeofenceRepository geofenceRepository})
    : _geofenceRepository = geofenceRepository;
  final GeofenceRepository _geofenceRepository;
  @override
  Future<Either<Failure, List<AgencyGeofence>>> call(void params) async {
    final geofences = await _geofenceRepository.fetchAgencyGeofences();
    return geofences.fold(Left.new, (geofences) async {
      await _geofenceRepository.registerGeofences(geofences);
      debugPrint('geofences: $geofences');
      return Right(geofences);
    });
  }
}
