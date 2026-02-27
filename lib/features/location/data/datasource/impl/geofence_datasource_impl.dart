import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:fpt_ojt/features/location/data/datasource/geofence_datasource.dart';
import 'package:fpt_ojt/features/location/data/mappers/geo_mapper.dart';
import 'package:fpt_ojt/features/location/data/models/geofence_dto.dart';
import 'package:fpt_ojt/features/location/domain/entities/geofence.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';
import 'package:geofence_service/geofence_service.dart';

class GeofenceDatasourceImpl implements GeofenceDatasource {
  GeofenceDatasourceImpl({
    required GeofenceService geofenceService,
    required Dio dio,
  }) : _geofenceService = geofenceService,
       _dio = dio;

  final GeofenceService _geofenceService;
  final Dio _dio;

  @override
  Future<void> register(List<AgencyGeofence> agencies) async {
    debugPrint('register geofences total: ${agencies.length}');
    final geofences = agencies.map((e) => e.toGeofence()).toList();
    await _geofenceService.start(geofences);
  }

  @override
  Future<void> unregisterAll() async {
    _geofenceService.clearGeofenceList();
  }

  @override
  Future<void> update(List<AgencyGeofence> agencies) async {
    await unregisterAll();
    await _geofenceService.stop();
    await register(agencies);
  }

  @override
  Future<ApiResponse<List<GeofenceDto>>> getGeofences() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/core/geofence/candidates',
    );
    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => (json! as List<dynamic>)
          .map((e) => GeofenceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
