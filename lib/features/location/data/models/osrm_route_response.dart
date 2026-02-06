import 'package:freezed_annotation/freezed_annotation.dart';

part 'osrm_route_response.freezed.dart';
part 'osrm_route_response.g.dart';

@freezed
abstract class OsrmRouteResponse with _$OsrmRouteResponse {
  const factory OsrmRouteResponse({
    required String code,
    required List<OsrmRoute> routes,
    required List<OsrmWaypoint> waypoints,
  }) = _OsrmRouteResponse;

  factory OsrmRouteResponse.fromJson(Map<String, dynamic> json) =>
      _$OsrmRouteResponseFromJson(json);
}

@freezed
abstract class OsrmRoute with _$OsrmRoute {
  const factory OsrmRoute({
    required double distance,
    required double duration,
    required double weight,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'weight_name') required String weightName,
    required OsrmGeometry geometry,
    required List<OsrmLeg> legs,
  }) = _OsrmRoute;

  factory OsrmRoute.fromJson(Map<String, dynamic> json) =>
      _$OsrmRouteFromJson(json);
}

@freezed
abstract class OsrmLeg with _$OsrmLeg {
  const factory OsrmLeg({
    required double distance,
    required double duration,
    required double weight,
    required String summary,
  }) = _OsrmLeg;

  factory OsrmLeg.fromJson(Map<String, dynamic> json) =>
      _$OsrmLegFromJson(json);
}

@freezed
abstract class OsrmGeometry with _$OsrmGeometry {
  const factory OsrmGeometry({
    required String type,
    required List<List<double>> coordinates,
  }) = _OsrmGeometry;

  factory OsrmGeometry.fromJson(Map<String, dynamic> json) =>
      _$OsrmGeometryFromJson(json);
}

@freezed
abstract class OsrmWaypoint with _$OsrmWaypoint {
  const factory OsrmWaypoint({
    required String hint,
    required List<double> location,
    required String name,
    required double distance,
  }) = _OsrmWaypoint;

  factory OsrmWaypoint.fromJson(Map<String, dynamic> json) =>
      _$OsrmWaypointFromJson(json);
}
