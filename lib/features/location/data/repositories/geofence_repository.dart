import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/location/data/datasource/geofence_datasource.dart';
import 'package:fpt_ojt/features/location/data/mappers/geo_mapper.dart';
import 'package:fpt_ojt/features/location/domain/entities/geofence.dart';
import 'package:fpt_ojt/features/location/domain/repositories/geofence_repository.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';

class GeofenceRepositoryImpl implements GeofenceRepository {
  GeofenceRepositoryImpl({required GeofenceDatasource geofenceDatasource})
    : _geofenceDatasource = geofenceDatasource;
  final GeofenceDatasource _geofenceDatasource;

  @override
  Future<Either<Failure, MerchantAgency>> fetchAgencyDetail(String agencyId) {
    // TODO: implement fetchAgencyDetail
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<AgencyGeofence>>> fetchAgencyGeofences() async {
    try {
      final response = await _geofenceDatasource.getGeofences();
      return Right(response.data!.map((e) => e.toDomain()).toList());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> registerGeofences(
    List<AgencyGeofence> geofences,
  ) async {
    try {
      debugPrint('register geofences: $geofences');
      await _geofenceDatasource.register(geofences);
      return const Right(null);
    } on Exception catch (e) {
      debugPrint('error register geofences: $e');
      return Left(Failure.fromException(e));
    }
  }
}
