import 'dart:math';

import 'package:equatable/equatable.dart';

class Coordinate extends Equatable {
  const Coordinate({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;

  int distanceTo(Coordinate other) => _calculateDistanceInMeters(this, other);

  int _calculateDistanceInMeters(Coordinate from, Coordinate to) {
    const earthRadius = 6371000;

    final dLat = _degToRad(to.latitude - from.latitude);
    final dLng = _degToRad(to.longitude - from.longitude);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(from.latitude)) *
            cos(_degToRad(to.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return (earthRadius * c).round();
  }

  double _degToRad(double deg) => deg * pi / 180;

  @override
  List<Object?> get props => [latitude, longitude];
}
