import 'package:equatable/equatable.dart';

class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class LocationStarted extends LocationEvent {
  const LocationStarted();
}

class LocationStopped extends LocationEvent {
  const LocationStopped();
}

class LocationRequested extends LocationEvent {
  const LocationRequested();
}

class LocationFailed extends LocationEvent {
  const LocationFailed(this.error);
  final String error;
  @override
  List<Object?> get props => [error];
}
