import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence_dto.freezed.dart';
part 'geofence_dto.g.dart';

@freezed
abstract class GeofenceDto with _$GeofenceDto {
  const factory GeofenceDto({
    required String id,
    required double latitude,
    required double longitude,
    @Default(100) double metersRadius,
  }) = _GeofenceDto;

  factory GeofenceDto.fromJson(Map<String, dynamic> json) =>
      _$GeofenceDtoFromJson(json);
}
