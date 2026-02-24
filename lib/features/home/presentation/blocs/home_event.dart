import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeCoordinateUpdated extends HomeEvent {
  const HomeCoordinateUpdated(this.coordinate);
  final Coordinate coordinate;
}

class SubscribeToMerchantToggled extends HomeEvent {
  const SubscribeToMerchantToggled(this.merchantAgencyId);
  final String merchantAgencyId;

  @override
  List<Object?> get props => [merchantAgencyId];
}

class FavoriteMerchantToggled extends HomeEvent {
  const FavoriteMerchantToggled(this.merchantAgencyId);
  final String merchantAgencyId;

  @override
  List<Object?> get props => [merchantAgencyId];
}

class HomeRefreshRequested extends HomeEvent {
  const HomeRefreshRequested({this.lat = 0, this.long = 0});
  final double? lat;
  final double? long;

  @override
  List<Object?> get props => [lat, long];
}
