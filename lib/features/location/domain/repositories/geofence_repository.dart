import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/location/domain/entities/geofence.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';

abstract class GeofenceRepository {
  Future<Either<Failure, List<AgencyGeofence>>> fetchAgencyGeofences();

  Future<Either<Failure, void>> registerGeofences(List<AgencyGeofence> geofences);

  Future<Either<Failure, MerchantAgency>> fetchAgencyDetail(String agencyId);
}
