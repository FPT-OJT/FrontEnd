import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/location/domain/usecases/get_shortest_distance.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';
import 'package:fpt_ojt/features/merchants/domain/repositories/merchant_agency_repository.dart';

class GetNearestMerchantAgenciesUseCase
    implements UseCase<List<MerchantAgency>, GetNearestMerchantAgenciesParams> {
  GetNearestMerchantAgenciesUseCase({
    required this.merchantAgencyRepository,
    required this.getShortestDistanceUseCase,
  });
  final MerchantAgencyRepository merchantAgencyRepository;
  final GetShortestDistanceUseCase getShortestDistanceUseCase;

  @override
  Future<Either<Failure, List<MerchantAgency>>> call(
    GetNearestMerchantAgenciesParams params,
  ) async {
    // Fetch nearest merchant agency candidates
    final candidatesResult = await merchantAgencyRepository
        .getNearestMerchantAgencies(
          limit: params.limit * 2,
          latitude: params.latitude,
          longitude: params.longitude,
        );

    return candidatesResult.fold(Left.new, (candidates) async {
      // User location coordinate
      final userLocation = Coordinate(
        latitude: params.latitude,
        longitude: params.longitude,
      );
      // Calculate distance for each agency
      final agenciesWithDistance = await Future.wait(
        candidates.map((agency) async {
          // Try to get shortest route distance from OSRM
          final distanceResult = await getShortestDistanceUseCase(
            GetShortestDistanceParams(from: userLocation, to: agency.location),
          );
          // Use OSRM distance if successful,
          // otherwise fallback to straight-line distance
          final distance = distanceResult.fold(
            (_) => userLocation.distanceTo(agency.location).toDouble(),
            (osrmDistance) => osrmDistance,
          );

          return agency.copyWith(distance: distance);
        }),
      );
      // Take top agencies based on requested limit
      final agenciesWithNonNullDistance = agenciesWithDistance
          .where((agency) => agency.distance != null)
          .toList();
      agenciesWithNonNullDistance
          .sort((a, b) => a.distance!.compareTo(b.distance!));
      final nearestAgencies =
          agenciesWithNonNullDistance.take(params.limit).toList();

      return Right(nearestAgencies);
    });
  }
}

@immutable
class GetNearestMerchantAgenciesParams extends Equatable {
  const GetNearestMerchantAgenciesParams({
    required this.limit,
    required this.latitude,
    required this.longitude,
  });
  final int limit;
  final double latitude;
  final double longitude;
  @override
  List<Object?> get props => [limit, latitude, longitude];
}
