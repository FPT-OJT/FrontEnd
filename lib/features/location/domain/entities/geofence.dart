import 'package:equatable/equatable.dart';

class AgencyGeofence extends Equatable {
  const AgencyGeofence({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });
  final String id;
  final double latitude;
  final double longitude;
  final double radius;

  @override
  List<Object?> get props => [id, latitude, longitude, radius];
}
